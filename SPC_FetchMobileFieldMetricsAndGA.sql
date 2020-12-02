--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileFieldMetricsAndGA' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileFieldMetricsAndGA 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileFieldMetricsAndGA]
(
	@UserId INT
)AS
BEGIN
	CREATE  TABLE #TempTable(ID INT IDENTITY(1,1),DateOfRegister DATE, UniqueSubjectID VARCHAR(500),SubjectId INT,GAatRegDate DECIMAL(10,1),SubType INT,RegisteredBy INT,
	SamplingStatus BIT,SampleCollectedBy INT,SampleTimeout BIT,SampleDamaged BIT,
	ShipmentDone BIT,ShipmentID VARCHAR(MAX), ShipmentBy INT, CurrentGA DECIMAL(10,1),[ROW NUMBER] INT)

	INSERT INTO  #TempTable (DateOfRegister,UniqueSubjectID,SubjectId,GAatRegDate,SubType,RegisteredBy,SamplingStatus,SampleCollectedBy,SampleTimeout,SampleDamaged,
	ShipmentDone,ShipmentID,ShipmentBy,CurrentGA,[ROW NUMBER])
	SELECT * FROM (
			SELECT	
				SPRD.[DateofRegister]
				,SPRD.[UniqueSubjectID]
				,SPRD.[ID] AS SubjectId
				,(SELECT [dbo].[FN_CalculateGAatRegDate](SPD.[SubjectID],SPRD.[DateofRegister])) AS [GAatRegDate]
				,SPRD.[ChildSubjectTypeID] AS SubType
				,SPRD.[CreatedBy]
				,CASE WHEN SC.[BarcodeNo] IS NULL THEN 0 ELSE 1 END  AS SamplingStatus
				,SC.[CollectedBy]
				,SC.[SampleTimeoutExpiry]
				,SC.[SampleDamaged]
				,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END ShipmentDone
				,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN NULL ELSE ACS.[GenratedShipmentID] END ShipmentID
				,ACS.[ANM_ID]
				,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS [CurrentGA]
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPAD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			WHERE SPRD.[AssignANM_ID] = @UserId AND SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail])
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC
		
		--SELECT * FROM #TempTable
		SELECT (SELECT COUNT(1) FROM #TempTable WHERE DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS NoOfRegistration ,
		(SELECT COUNT(1) FROM #TempTable WHERE SamplingStatus=1 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS SampleCollected,
		(SELECT COUNT(1) FROM #TempTable WHERE SamplingStatus=0 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS PendingSampleCollection,
		--(SELECT COUNT(1) FROM #TempTable WHERE ShipmentDone=1 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS ShipmentDone,
		--(SELECT COUNT(1) FROM #TempTable WHERE ShipmentDone=1 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS ShipmentLog,
		(SELECT COUNT(DISTINCT(ShipmentID)) FROM #TempTable WHERE ShipmentDone=1 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND ShipmentBy = @UserId)AS ShipmentDone,
		(SELECT COUNT(1) FROM #TempTable WHERE SamplingStatus=1 AND  ShipmentDone=0 AND  DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE() AND SampleCollectedBy = @UserId AND SampleTimeout=0 AND SampleDamaged=0) AS UnsentSamples,
		(SELECT COUNT(1) FROM #TempTable WHERE GAatRegDate<10 AND SubType=1 AND DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS [GALT10],
		(SELECT COUNT(1) FROM #TempTable WHERE GAatRegDate>=10  AND GAatRegDate<15 AND SubType=1 AND DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) 
		AS [GAGTE10GALT15],
		(SELECT COUNT(1) FROM #TempTable WHERE GAatRegDate>=15 AND SubType=1 AND DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS [GAGTE15],
		(SELECT COUNT(1) FROM #TempTable WHERE CurrentGA>=15 AND SubType=1 AND DateOfRegister BETWEEN DATEADD(MONTH,-6,GETDATE()) AND GETDATE()) AS [CurrentGAGTE15]
		DROP TABLE #TempTable
END