--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_ANMReCollectionReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_ANMReCollectionReport  --'','',1,0,0,2
END
GO
CREATE PROCEDURE [dbo].[SPC_ANMReCollectionReport]
(
	@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@ANMID INT
	,@RIID INT
	,@SubjectType INT
	,@Status INT
)AS
BEGIN
	DECLARE  @StartDate VARCHAR(50), @EndDate VARCHAR(50)
		
	IF @FromDate = NULL OR @FromDate = ''
	BEGIN
		SET @StartDate = (SELECT CONVERT(VARCHAR,DATEADD(MONTH ,-3,GETDATE()),103))
	END
	ELSE
	BEGIN
		SET @StartDate = @FromDate
	END
	IF @ToDate = NULL OR @ToDate = ''
	BEGIN
		SET @EndDate = (SELECT CONVERT(VARCHAR,GETDATE(),103)) + ' 23:59:59'
	END
	ELSE
	BEGIN
		SET @EndDate = @ToDate
	END

	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1), ANMID VARCHAR(100), ANMName VARCHAR(MAX), UniqueSubjectId VARCHAR(250), SubjectName VARCHAR(MAX),  SubjectType VARCHAR(150),
	RCHID VARCHAR(250), DateOfRegister VARCHAR(250), Barcode VARCHAR(150), RI VARCHAR(250), MobileNo VARCHAR(200), GA VARCHAR(10), SampleCollected VARCHAR(20), SampleCollectionDateTime VARCHAR(250),
	FirstTimeRecollected VARCHAR(250), RecollectedDateTime VARCHAR(250),
	ShipmentDone VARCHAR(20), ShipmentDateTime VARCHAR(250), ShipmentId VARCHAR(250), TestResult VARCHAR(MAX), CHCShipmentDateTime VARCHAR(250),
	HPLCPathoDiagnosis VARCHAR(MAX), PNDT VARCHAR(MAX), MTP VARCHAR(MAX), CurrentStatus VARCHAR(MAX),
	[ROW NUMBER] INT) 
		
	INSERT INTO #TempReportDetail (ANMID, ANMName, UniqueSubjectId, SubjectName, SubjectType, RCHID, DateOfRegister, Barcode, RI, MobileNo, GA, SampleCollected, SampleCollectionDateTime, FirstTimeRecollected, RecollectedDateTime,
	ShipmentDone, ShipmentDateTime, ShipmentId,  TestResult, CHCShipmentDateTime,HPLCPathoDiagnosis, PNDT, MTP, CurrentStatus,[ROW NUMBER])
	SELECT * FROM (
		SELECT	UM.[User_gov_code] AS ANMID
			,(UM.[FirstName]+ ' ' +UM.[LastName]) AS ANMName
			,SPRD.[UniqueSubjectID]
			,(SPRD.[FirstName] + ' ' + SPRD.[LastName]) AS SubjectName
			,ST.[SubjectType]
			,SPD.[RCHID]
			,CONVERT(VARCHAR,SPRD.[DateofRegister],103) AS DateofRegister
			,CASE WHEN SC.[ID] IS NULL THEN '--'  ELSE SC.[BarcodeNo] END AS Barcode
			,R.[RIsite] AS RI
			,SPRD.[MobileNo]
			,CASE WHEN SPRD.[ChildSubjectTypeID] = 1 THEN (SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) ELSE '--' END AS [GA] 
			,CASE WHEN SC.[ID] IS NULL THEN 'No' WHEN SC.[SampleTimeoutExpiry] = 1 THEN 'Timeout Expiry' WHEN SC.[SampleDamaged] =1 THEN 'Sample Damaged' ELSE 'Yes' END AS SampleCollected
			,CASE WHEN SC.[ID] IS NULL THEN '--' ELSE (CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) END AS SampleCollectionDateTime
			,CASE WHEN SC.[ID] IS NULL THEN 'Pending' WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) > 1 THEN 'Recollected' 
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleTimeoutExpiry] = 1) THEN 'Timeout Expiry'
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleDamaged] = 1) THEN 'Sample Damaged'
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleDamaged] = 0 AND SC.[SampleTimeoutExpiry] = 0) THEN 'First Time'
				END AS FirstTimeRecollected
			,CASE WHEN SC.[ID] IS NULL THEN '--' WHEN (SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) > 1 THEN 
				(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108)) 
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleTimeoutExpiry] = 1) THEN '--'
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleDamaged] = 1) THEN '--'
				WHEN ((SELECT COUNT(ID) FROM Tbl_SampleCollection WHERE UniqueSubjectID = SPRD.[UniqueSubjectID]) = 1  AND SC.[SampleDamaged] = 0 AND SC.[SampleTimeoutExpiry] = 0) THEN 
				(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' +CONVERT(VARCHAR(5),SC.[SampleCollectionTime],108))
				END AS RecollectedDateTime
			,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN  'No' ELSE 'Yes' END AS ShipmentDone
			,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN  '--' ELSE (CONVERT(VARCHAR,ACS.[DateofShipment],103) + ' ' +CONVERT(VARCHAR(5),ACS.[TimeofShipment],108)) END AS ShipmentDateTime
			,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN  '--' ELSE ACS.[GenratedShipmentID] END AS ShipmentId
			,'--' AS TestResult
			,'--' AS CHCShipmentDateTime
			,'--' AS HPLCPathoDiagnosis
			,'--' AS PNDT
			,'--' AS MTP
			,(SELECT  [dbo].[FN_FindSubjectStage](SPRD.[UniqueSubjectID])) AS CurrentStatus
			,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
		FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SPRD.[ChildSubjectTypeID]
		LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
		LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
		LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SPRD.[AssignANM_ID]
		LEFT JOIN [dbo].[Tbl_RIMaster] R WITH (NOLOCK) ON R.[ID] = SPRD.[RIID]
		WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail])
		AND(SPRD.[DateofRegister] BETWEEN  CONVERT(DATETIME,@StartDate,103) AND CONVERT(DATETIME,@EndDate,103))
		AND SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SampleCollection])
		AND (SPRD.[RIID] = @RIID OR @RIID = 0)
		AND (SPRD.[ChildSubjectTypeID] = @SubjectType OR @SubjectType = 0)
		AND SPRD.[AssignANM_ID] = @ANMID
		AND SC.[CollectionFrom] = 10
	)GROUPS
	WHERE GROUPS.[ROW NUMBER] = 1 
	ORDER BY GROUPS.UniqueSubjectID ASC

	IF @Status = 1
	BEGIN

		SELECT * FROM #TempReportDetail WHERE FirstTimeRecollected = 'Recollected'
	END
	IF @Status = 2
	BEGIN

		SELECT * FROM #TempReportDetail  WHERE (FirstTimeRecollected = 'Timeout Expiry' OR FirstTimeRecollected = 'Sample Damaged' )
	END
	DROP Table #TempReportDetail
END