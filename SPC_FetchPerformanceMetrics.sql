--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPerformanceMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPerformanceMetrics  --'14/10/2020','20/11/2020'
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPerformanceMetrics] (@FromDate VARCHAR(200), @ToDate VARCHAR(200))
AS
DECLARE @StartDate DATE, @EndDate DATE
BEGIN
	
	SET @StartDate = CONVERT(DATE,@FromDate,103)
	SET @EndDate = CONVERT(DATE,@ToDate,103)

	CREATE  TABLE #TempRepTable(ID INT IDENTITY(1,1),DateOfRegister DATE, UniqueSubjectID VARCHAR(500), SubjectCreatedOn DATE,RegistrationFrom INT,
	CollectionFrom INT,ShipmentFrom INT, SamplingStatus BIT,
	SampleCollectionDate DATE, SampleCreatedOn DATE, ShipmentDone BIT,DateOfShipment DATE, ShipmentCreatedOn DATE,SampleProcessedOn DATE,
	SampleTimeoutExpiry BIT,SampleDamaged BIT,CHCShipmentReceivedDate DATE,CBCTestDone BIT,CBCTestedDate DATE, CBCCreatedOn DATE,SSTestDone BIT,
	SSTCreatedOn DATE,CHCShipmentDone BIT,CHCDateOfShipment DATE, [ROW NUMBER] INT)

	INSERT INTO  #TempRepTable (DateOfRegister,UniqueSubjectID,SubjectCreatedOn,RegistrationFrom,CollectionFrom,ShipmentFrom,
	SamplingStatus,SampleCollectionDate,SampleCreatedOn,
	ShipmentDone,DateOfShipment,ShipmentCreatedOn,SampleProcessedOn,SampleTimeoutExpiry,SampleDamaged,CHCShipmentReceivedDate,CBCTestDone,
	CBCTestedDate,	CBCCreatedOn,SSTestDone,SSTCreatedOn,CHCShipmentDone,CHCDateOfShipment
	,[ROW NUMBER])
	SELECT * FROM (
			SELECT	
				SPRD.[DateofRegister]
				,SPRD.[UniqueSubjectID]
				,SPRD.[CreatedOn] AS SubjectCreatedOn 
				,SPRD.[RegisteredFrom]
				,SC.[CollectionFrom]
				,ACS.[ShipmentFrom]
				,CASE WHEN SC.[BarcodeNo] IS NULL THEN 0 ELSE 1 END  AS SamplingStatus
				,SC.[SampleCollectionDate]
				,SC.[CreatedOn] AS SampleCreatedOn
				,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END ShipmentDone
				,ACS.[DateofShipment]
				,ACS.[CreatedOn] AS ShipmentCreatedOn
				,CTD.[CreatedOn] AS SampleProcessedOn
				,SC.[SampleTimeoutExpiry]
				,SC.[SampleDamaged]
				,ACS.[ReceivedDate] AS CHCShipmentReceivedDate
				,CASE WHEN CTD.[ID] IS NULL THEN 0 ELSE 1 END CBCTestDone
				,CTD.[TestedDateTime] AS CBCTestedDate
				,CTD.[CreatedOn] AS CBCCreatedOn
				,CASE WHEN SST.[ID] IS NULL THEN 0 ELSE 1 END SSTestDone
				,SST.[CreatedOn] AS SSTCreatedOn
				,CASE WHEN CCS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END CHCShipmentDone
				,CCS.[DateofShipment] AS CHCDateOfShipment
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPAD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_CBCTestedDetail] CTD  WITH (NOLOCK) ON CTD.[Barcode] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail] CSD WITH (NOLOCK) ON CSD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CHCShipments] CCS WITH (NOLOCK) ON CCS.[ID] = CSD.[ShipmentID]
			--LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD  WITH (NOLOCK) ON HTD.[Barcode] = SC.[BarcodeNo]
			WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail]) AND (CTD.[ConfirmationStatus] = 1 OR CTD.[ConfirmationStatus] IS NULL)
		--AND (HTD.[SampleStatus] = 1 OR HTD.[SampleStatus] IS NULL)
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC

		--SELECT * FROM #TempRepTable
		SELECT 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate)) AS NoOfRegistration ,
		
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND DateOfRegister = SampleProcessedOn) AS SubRegDateEqualSampleProcessedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SubjectCreatedOn > DateOfRegister) AS SubCreatedOnGreaterSubRegDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE DateOfRegister BETWEEN @StartDate AND @EndDate 
		AND DateOfRegister = SampleProcessedOn) * 100) / (SELECT COUNT(1) FROM #TempRepTable WHERE DateOfRegister BETWEEN @StartDate AND @EndDate)))+' %'
		AS PercentageofRegSystemEntry,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate)
		AND DateOfRegister = SubjectCreatedOn) AS SubRegDateEqualSubCreatedOn,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate)
		AND DateOfRegister = SubjectCreatedOn) * 100) / (SELECT COUNT(1) FROM #TempRepTable WHERE DateOfRegister BETWEEN @StartDate AND @EndDate)))+' %'
		AS PercentageofRegSyncEntry,

		(SELECT COUNT(1) FROM #TempRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)) AS NoOfSampleCollected,


		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND DateOfRegister = SampleCollectionDate) AS SubRegDateEqualSampleCollectedDate,
		
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleCollectionDate > DateOfRegister) AS SampleCollectedDateGreaterSubRegDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND DateOfRegister = SampleCollectionDate) * 100) /(SELECT COUNT(1) FROM #TempRepTable WHERE SamplingStatus=1 AND 
		(DateOfRegister BETWEEN @StartDate AND @EndDate))))+' %' AS PercentageofSampleSystemEntry,


		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND(SampleCreatedOn IS NOT NULL) AND SampleCreatedOn = SampleCollectionDate) AS SampleCollectedDateEqualSampleCreatedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND(SampleCreatedOn IS NOT NULL) AND SampleCreatedOn > SampleCollectionDate) AS SampleCreatedOnGreaterSampleCollectedDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND(SampleCreatedOn IS NOT NULL) AND SampleCreatedOn = SampleCollectionDate) * 100) /(SELECT COUNT(1) FROM #TempRepTable WHERE SamplingStatus=1 AND 
		(DateOfRegister BETWEEN @StartDate AND @EndDate))))+' %' AS PercentageofSampleSyncEntry,

		(SELECT COUNT(1) FROM #TempRepTable WHERE ShipmentDone=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)) AS NoOfShipmentDone,


		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND (DateofShipment IS NOT NULL) AND DateOfShipment = SampleCollectionDate) AS SampleCollectedDateEqualShipmentDate,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND (DateofShipment IS NOT NULL) AND DateOfShipment > SampleCollectionDate) AS ShipmentDateGreaterSampleCollectedDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND (DateofShipment IS NOT NULL) AND DateOfShipment = SampleCollectionDate) * 100) /(SELECT COUNT(1) FROM #TempRepTable WHERE ShipmentDone=1 AND  
		(DateOfRegister BETWEEN @StartDate AND @EndDate))))+' %' AS PercentageofShipmentSystemEntry,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (DateofShipment IS NOT NULL)
		AND (ShipmentCreatedOn IS NOT NULL) AND DateOfShipment = ShipmentCreatedOn) AS ShipmentDateEqualShipmentCreatedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (SampleCollectionDate IS NOT NULL)
		AND (DateofShipment IS NOT NULL) AND ShipmentCreatedOn > DateOfShipment) AS ShipmentCreatedOnGreaterShipmentDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (DateofShipment IS NOT NULL)
		AND (ShipmentCreatedOn IS NOT NULL) AND DateOfShipment = ShipmentCreatedOn) * 100) /(SELECT COUNT(1) FROM #TempRepTable WHERE ShipmentDone=1 AND  
		(DateOfRegister BETWEEN @StartDate AND @EndDate))))+' %' AS PercentageofShipmentSyncEntry,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleTimeoutExpiry = 1) AS TotalNoOfSampleTimeOut,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleTimeoutExpiry = 1) * 100) / (SELECT COUNT(1) FROM #TempRepTable WHERE DateOfRegister BETWEEN @StartDate AND @EndDate)))+' %'
		AS PercentageofSampleTimeout,


		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL) AS TotalNoOfSamplesReceived,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL AND CHCShipmentReceivedDate = ShipmentCreatedOn) AS ShpmentRecdDateEqualShipmentCreatedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL AND CHCShipmentReceivedDate > ShipmentCreatedOn) AS ShpmentRecdDategreaterShipmentCreatedOn,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL AND CHCShipmentReceivedDate = ShipmentCreatedOn) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CHCShipmentReceivedDate IS NOT NULL)))+' %'
		AS PercentageofSampleReceipt,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CBCTestDone = 1) AS TotalNoOfSamplesCBCTested,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CBCTestDone = 1  AND CBCTestedDate = CHCShipmentReceivedDate) AS CBCTestedDateEqualCHCReceivedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CBCTestDone = 1 AND CBCTestedDate > CHCShipmentReceivedDate) AS CBCTestedDateGreaterCHCReceivedOn,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CBCTestDone = 1 AND CBCTestedDate = CHCShipmentReceivedDate) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CBCTestDone = 1)))+' %' AS PercentageofCBCTest,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SSTestDone = 1) AS TotalNoOfSamplesSSTTested,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SSTestDone = 1  AND SSTCreatedOn = CHCShipmentReceivedDate) AS SSTTestedDateEqualCHCReceivedOn,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SSTestDone = 1 AND SSTCreatedOn > CHCShipmentReceivedDate) AS SSTTestedDateGreaterCHCReceivedOn,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SSTestDone = 1 AND SSTCreatedOn = CHCShipmentReceivedDate) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SSTestDone = 1)))+' %' AS PercentageofSSTest,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentDone = 1) AS TotalNoOfCHCShipmentDone,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentDone = 1 AND CHCDateOfShipment = CBCTestedDate) AS CHCShipmentDateEqualCBCTestedDate,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentDone = 1 AND CHCDateOfShipment > CBCTestedDate) AS CHCShipmentDateGreaterCBCTestedDate,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentDone = 1 AND CHCDateOfShipment = CBCTestedDate) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentDone = 1)))+' %' AS PercentageofPosiveSamplesShipped,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleTimeoutExpiry = 1) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL)))+' %' AS PercentageofSampleTimeoutRecevedFromANM,

		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleDamaged = 1) AS TotalNoOfSampleDamaged,

		CONVERT(VARCHAR,(((SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND SampleDamaged = 1) * 100) / 
		(SELECT COUNT(1) FROM #TempRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		AND CHCShipmentReceivedDate IS NOT NULL)))+' %' AS PercentageofSampleDamaged,

		(Select COUNT(DISTINCT(Barcode)) FROM Tbl_CBCTestedDetail  WHERE Barcode <>'INVALID' AND Barcode NOT Like 'AUTO%') AS ActualRegPhysicalSampleAtCHC, 

		(SELECT COUNT(DISTINCT(AssignANM_ID)) FROM Tbl_SubjectPrimaryDetail SP 
		LEFT JOIN TBL_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
		WHERE SP.DateofRegister    BETWEEN @StartDate AND @EndDate AND UM.UserRole_ID = 3) AS NoOfANMWorkingatDates

		DROP TABLE #TempRepTable
END