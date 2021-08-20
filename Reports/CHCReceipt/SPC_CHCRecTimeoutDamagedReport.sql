--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_CHCRecTimeoutDamagedReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_CHCRecTimeoutDamagedReport 
END
GO
CREATE PROCEDURE [dbo].[SPC_CHCRecTimeoutDamagedReport]
(
	@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@CHCID INT
	,@PHCID INT
	,@ANMID INT
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

	 

	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1), ANMID VARCHAR(100), ANMName VARCHAR(MAX), ANMContact VARCHAR(200), 
	UniqueSubjectId VARCHAR(250),  SubjectName VARCHAR(MAX), SubjectType VARCHAR(150), 
	RCHID VARCHAR(250), Barcode VARCHAR(150), TimeoutDamaged VARCHAR(100), 
	ShipmentDateTime VARCHAR(250), ShipmentId VARCHAR(250), ShipmentReceivedDate VARCHAR(200),TestDateTime VARCHAR(MAX),
	 TestResult VARCHAR(MAX), CHCShipmentDateTime VARCHAR(250),CHCShipmentId VARCHAR(200),[ROW NUMBER] INT) 


	IF @Status = 1
	BEGIN
		
		INSERT INTO #TempReportDetail (ANMID, ANMName, ANMContact, UniqueSubjectId, SubjectName, SubjectType, RCHID, Barcode, TimeoutDamaged, 
		ShipmentDateTime, ShipmentId, ShipmentReceivedDate,TestDateTime, TestResult, CHCShipmentDateTime,CHCShipmentId,[ROW NUMBER])
		SELECT * FROM (
			SELECT	UM.[User_gov_code] AS ANMID
				,(UM.[FirstName]+ ' ' +UM.[LastName]) AS ANMName
				,UM.[ContactNo1] AS ANMContactNo
				,SPRD.[UniqueSubjectID]
				,(SPRD.[FirstName] + ' ' + SPRD.[LastName]) AS SubjectName
				,ST.[SubjectType]
				,SPD.[RCHID]
				,CASE WHEN SC.[ID] IS NULL THEN '--'  ELSE SC.[BarcodeNo] END AS Barcode
				,'Sample Timeout' AS TimeoutDamaged
				,(CONVERT(VARCHAR,ACS.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),ACS.[TimeofShipment],108))  AS ShipmentDateTime
				, ACS.[GenratedShipmentID]  AS ShipmentId
				,CASE  WHEN ISNULL(ACS.[ReceivedDate],'') = '' THEN '--' ELSE CONVERT(VARCHAR,ACS.[ReceivedDate],103) END AS ShipmentReceivedDate
				,'--' AS TestDateTime
				,'--' AS TestResult
				,'--' AS CHCShipmentDateTime
				,'--' AS CHCShipmentId
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SPRD.[ChildSubjectTypeID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SPRD.[AssignANM_ID]
			WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail])
			AND(ACS.[DateofShipment] BETWEEN  CONVERT(DATETIME,@StartDate,103) AND CONVERT(DATETIME,@EndDate,103))
			AND SPRD.[UniqueSubjectID] IN (SELECT UniqueSubjectID FROM [dbo].[Tbl_ANMCHCShipmentsDetail]) 
			AND (SPRD.[CHCID] = @CHCID OR @CHCID = 0)
			AND (SPRD.[PHCID] = @PHCID OR @PHCID = 0)
			AND (SPRD.[AssignANM_ID] = @ANMID OR @ANMID = 0)
				AND SC.[IsAccept] = 0 AND ASD.[SampleTimeoutExpiry] = 1 AND SC.[RejectAt] = 'CHC Receipt'
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC
	END
	IF @Status = 2 
	BEGIN
		
		INSERT INTO #TempReportDetail (ANMID, ANMName, ANMContact, UniqueSubjectId, SubjectName, SubjectType, RCHID, Barcode, TimeoutDamaged, 
		ShipmentDateTime, ShipmentId, ShipmentReceivedDate,TestDateTime, TestResult, CHCShipmentDateTime,CHCShipmentId,[ROW NUMBER])
		SELECT * FROM (
			SELECT	UM.[User_gov_code] AS ANMID
				,(UM.[FirstName]+ ' ' +UM.[LastName]) AS ANMName
				,UM.[ContactNo1] AS ANMContactNo
				,SPRD.[UniqueSubjectID]
				,(SPRD.[FirstName] + ' ' + SPRD.[LastName]) AS SubjectName
				,ST.[SubjectType]
				,SPD.[RCHID]
				,CASE WHEN SC.[ID] IS NULL THEN '--'  ELSE SC.[BarcodeNo] END AS Barcode
				,'Sample Damaged' AS TimeoutDamaged
				,(CONVERT(VARCHAR,ACS.[DateofShipment],103) + ' ' + CONVERT(VARCHAR(5),ACS.[TimeofShipment],108))  AS ShipmentDateTime
				, ACS.[GenratedShipmentID]  AS ShipmentId
				,CASE  WHEN ISNULL(ACS.[ReceivedDate],'') = '' THEN '--' ELSE CONVERT(VARCHAR,ACS.[ReceivedDate],103) END AS ShipmentReceivedDate
				,'--' AS TestDateTime
				,'--' AS TestResult
				,'--' AS CHCShipmentDateTime
				,'--' AS CHCShipmentId
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SPRD.[ChildSubjectTypeID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SPRD.[AssignANM_ID]
			WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail])
			AND(ACS.[DateofShipment] BETWEEN  CONVERT(DATETIME,@StartDate,103) AND CONVERT(DATETIME,@EndDate,103))
			AND SPRD.[UniqueSubjectID] IN (SELECT UniqueSubjectID FROM [dbo].[Tbl_ANMCHCShipmentsDetail]) 
			AND (SPRD.[CHCID] = @CHCID OR @CHCID = 0)
			AND (SPRD.[PHCID] = @PHCID OR @PHCID = 0)
			AND (SPRD.[AssignANM_ID] = @ANMID OR @ANMID = 0)
			AND SC.[IsAccept] = 0 AND ASD.[SampleDamaged] = 1 AND SC.[RejectAt] = 'CHC Receipt'
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC
	END

	SELECT * FROM #TempReportDetail

	DROP Table #TempReportDetail
END