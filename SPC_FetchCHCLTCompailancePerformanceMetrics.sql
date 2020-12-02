--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCLTCompailancePerformanceMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCLTCompailancePerformanceMetrics --'18/11/2020','18/11/2020',0,0,0
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCLTCompailancePerformanceMetrics] 
(
	@FromDate VARCHAR(200)
	,@ToDate VARCHAR(200)
	,@DistrictId INT
	,@BlockId INT
	,@CHCId INT
	
)

AS
	DECLARE @StartDate DATETIME, @EndDate DATETIME, @EndDateTime VARCHAR(100)
	DECLARE @A1 INT, @A2 INT, @A3 INT, @A4 INT
			,@B1 INT, @B2 INT, @B3 INT, @B4 INT
			,@C1 INT, @C2 INT, @C3 INT, @C4 INT
			,@D1 INT, @D2 INT, @D3 INT
			,@E1 INT, @E2 INT, @E3 INT, @E4 INT
			,@F1 INT, @F2 INT, @F3 INT, @F4 INT
			,@G1 INT, @G2 INT, @G3 INT, @G4 INT
			,@H1 INT, @H2 INT, @H3 INT, @H4 INT
			,@I1 INT, @I2 INT, @I3 INT
			,@J1 INT, @J2 INT, @J3 INT

			,@K1 INT, @K2 INT, @K3 INT, @K4 INT
			,@L1 INT, @L2 INT, @L3 INT, @L4 INT
			,@M1 INT, @M2 INT, @M3 INT, @M4 INT
			,@N1 INT, @N2 INT, @N3 INT, @N4 INT
			,@O1 INT, @O2 INT, @O3 INT
			,@P1 INT, @P2 INT, @P3 INT 
			,@Q1 INT, @Q2 INT, @Q3 INT, @Q4 INT
BEGIN
	SET @StartDate = CONVERT(DATETIME,@FromDate,103)
	SET @EndDateTime = @ToDate + ' 23:59:59'
	SET @EndDate = CONVERT(DATETIME,@EndDateTime,103)
	Print @EndDate

	CREATE  TABLE #TempANMCompaileanceRepTable(ID INT IDENTITY(1,1), UniqueSubjectID VARCHAR(500), DateOfRegister DATETIME, SubjectCreatedOn DATETIME, RegistrationFrom INT,
	 SamplingStatus BIT, Barcode VARCHAR(200),SampleCollectionDate DATE, SampleCollectionTime TIME(2), SampleCollectionDateTime DATETIME, SampleCreatedOn DATETIME,CollectionFrom INT,SampleTimeoutExpiry BIT,SampleDamaged BIT,
	 ShipmentStatus BIT, ShipmentFrom INT, DateOfShipment DATETIME,  TimeOfShipment TIME(2), ShipmentDateTime DATETIME, ShipmentCreatedOn DATETIME, ReceivedDate DATETIME, ReceivedDateCreatedOn DATETIME, CHCSampleTimeout BIT, CHCSampleDamaged BIT,
	 CBCTestStatus BIT, CBCTestedDate DATETIME, CBCTestCreatedOn DATETIME, CBCResult BIT,
	 SSTTestStatus BIT, SSTCreatedOn DATETIME, SSTResult BIT,
	 CHCtoCentralShipmentStatus BIT, CHCtoCentralDateOfShipment DATETIME,  CHCtoCentralTimeOfShipment TIME(2), CHCtoCentralShipmentDateTime DATETIME, 
	 CHCtoCentralShipmentCreatedOn DATETIME, CHCtoCentralReceivedDate DATETIME, CHCtoCentralReceivedDateCreatedOn DATETIME, CLLabSampleTimeout BIT, CLLabSampleDamaged BIT,
	 HPLCTestStatus BIT, HPLCTestedDate DATETIME, HPLCTestCreatedOn DATETIME, HPLCTestConfirmationOn DATETIME, HPLCSampleStatus INT,
	 HPLCTestPathoStatus BIT,  HPLCDiagnosisComplete BIT, HPLCDiagnosisCompletedOn DATETIME,
	 CentraltoMolecularShipmentStatus BIT, CentraltoMolecularDateOfShipment DATETIME, CentraltoMolecularTimeOfShipment TIME(2), CentraltoMolecularShipmentDateTime DATETIME, 
	 CentraltoMolecularShipmentCreatedOn DATETIME, CentraltoMolecularReceivedDate DATETIME, CentraltoMolecularReceivedDateCreatedOn DATETIME,
	 [ROW NUMBER] INT)

	 INSERT INTO #TempANMCompaileanceRepTable(UniqueSubjectID, DateOfRegister, SubjectCreatedOn, RegistrationFrom,
	 SamplingStatus, Barcode,SampleCollectionDate, SampleCollectionTime, SampleCollectionDateTime, SampleCreatedOn,CollectionFrom,SampleTimeoutExpiry,SampleDamaged,
	 ShipmentStatus, ShipmentFrom, DateOfShipment, TimeOfShipment, ShipmentDateTime, ShipmentCreatedOn, ReceivedDate, ReceivedDateCreatedOn,CHCSampleTimeout, CHCSampleDamaged,
	 CBCTestStatus, CBCTestedDate, CBCTestCreatedOn, CBCResult,
	 SSTTestStatus, SSTCreatedOn, SSTResult,
	 CHCtoCentralShipmentStatus, CHCtoCentralDateOfShipment,  CHCtoCentralTimeOfShipment, CHCtoCentralShipmentDateTime, 
	 CHCtoCentralShipmentCreatedOn, CHCtoCentralReceivedDate, CHCtoCentralReceivedDateCreatedOn, CLLabSampleTimeout, CLLabSampleDamaged,
	 HPLCTestStatus, HPLCTestedDate, HPLCTestCreatedOn, HPLCTestConfirmationOn, HPLCSampleStatus, 
	 HPLCTestPathoStatus, HPLCDiagnosisComplete, HPLCDiagnosisCompletedOn,
	 CentraltoMolecularShipmentStatus, CentraltoMolecularDateOfShipment, CentraltoMolecularTimeOfShipment, CentraltoMolecularShipmentDateTime, 
	 CentraltoMolecularShipmentCreatedOn, CentraltoMolecularReceivedDate, CentraltoMolecularReceivedDateCreatedOn,
	 [ROW NUMBER])
	 SELECT * FROM (
			SELECT	SPRD.[UniqueSubjectID]
				,SPRD.[DateofRegister]
				,SPRD.[CreatedOn] AS SubjectCreatedOn 
				,SPRD.[RegisteredFrom]
				,CASE WHEN SC.[BarcodeNo] IS NULL THEN 0 ELSE 1 END  AS SamplingStatus
				,SC.[BarcodeNo]
				,SC.[SampleCollectionDate]
				,SC.[SampleCollectionTime]
				,CONVERT(DATETIME,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' '+CONVERT(VARCHAR,SC.[SampleCollectionTime])),103) AS SampleCollectionDateTime
				,SC.[CreatedOn] AS SampleCreatedOn
				,SC.[CollectionFrom]
				,SC.[SampleTimeoutExpiry]
				,SC.[SampleDamaged]
				,CASE WHEN ACS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END ShipmentStatus
				,ACS.[ShipmentFrom]
				,ACS.[DateofShipment]
				,ACS.[TimeofShipment]
				,CONVERT(DATETIME,(CONVERT(VARCHAR,ACS.[DateofShipment],103) + ' '+CONVERT(VARCHAR,ACS.[TimeofShipment])),103) AS ShipmentDateTime
				,ACS.[CreatedOn] AS ShipmentCreatedOn
				,ACS.[ReceivedDate] AS CHCShipmentReceivedDate
				,ACS.[UpdatedOn] AS ReceivedDateCreatedOn
				,ASD.[SampleTimeoutExpiry] AS CHCSampleTimeout
				,ASD.[SampleDamaged] AS CHCSampleDamaged
				,CASE WHEN CTD.[ID] IS NULL THEN 0 ELSE 1 END CBCTestStatus
				,CTD.[TestedDateTime] AS CBCTestedDate
				,CTD.[CreatedOn] AS CBCTestCreatedOn
				,CBC.[IsPositive] AS CBCResult
				,CASE WHEN SST.[ID] IS NULL THEN 0 ELSE 1 END SSTTestStatus
				,SST.[CreatedOn] AS SSTCreatedOn
				,SST.[IsPositive] AS SSTResult
				,CASE WHEN CCS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END CHCtoCentralShipmentStatus
				,CCS.[DateofShipment] AS CHCtoCentralDateOfShipment
				,CCS.[TimeofShipment] AS CHCtoCentralTimeOfShipment
				,CONVERT(DATETIME,(CONVERT(VARCHAR,CCS.[DateofShipment],103) + ' '+CONVERT(VARCHAR,CCS.[TimeofShipment])),103) AS CHCtoCentralShipmentDateTime
				,CCS.[CreatedOn] AS CHCtoCentralShipmentCreatedOn
				,CCS.[ReceivedDate] AS CHCtoCentralReceivedDate
				,CCS.[UpdatedOn] AS CHCtoCentralReceivedDateCreatedOn
				,CSD.[SampleTimeoutExpiry] AS CLLabSampleTimeout
				,CSD.[SampleTimeoutExpiry] AS CLLabSampleDamaged
				,CASE WHEN HTD.[ID] IS NULL THEN 0 ELSE 1 END HPLCTestStatus
				,HTD.[TestedDateTime] AS HPLCTestedDate
				,HTD.[CreatedOn] AS HPLCTestCreatedOn
				,HT.[CreatedOn] AS HPLCTestConfirmationOn
				,HTD.[SampleStatus] AS HPLCSampleStatus
				,CASE WHEN HD.[ID] IS NULL THEN 0 ELSE 1 END HPLCTestPathoStatus
				,HD.[IsDiagnosisComplete] HPLCDiagnosisComplete
				,HD.[UpdatedOn] AS HPLCDiagnosisCompletedOn
				,CASE WHEN CLCS.[GenratedShipmentID] IS NULL THEN 0 ELSE 1 END CentraltoMolecularShipmentStatus
				,CLCS.[DateofShipment] AS CentraltoMolecularDateOfShipment
				,CLCS.[TimeofShipment] AS CentraltoMolecularTimeOfShipment
				,CONVERT(DATETIME,(CONVERT(VARCHAR,CLCS.[DateofShipment],103) + ' '+CONVERT(VARCHAR,CLCS.[TimeofShipment])),103) AS CentraltoMolecularShipmentDateTime
				,CLCS.[CreatedOn] AS CentraltoMolecularShipmentCreatedOn
				,CLCS.[ReceivedDate] AS CentraltoMolecularReceivedDate
				,CLCS.[UpdatedOn] AS CentraltoMolecularReceivedDateCreatedOn
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPAD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_CBCTestedDetail] CTD  WITH (NOLOCK) ON CTD.[Barcode] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.[BarcodeNo] = ASD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = ASD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SPRD.[CHCID]
			LEFT JOIN [dbo].[Tbl_BlockMaster] BM WITH (NOLOCK) ON BM.[ID] = CM.[BlockID]
			LEFT JOIN [dbo].[Tbl_CHCShipmentsDetail] CSD WITH (NOLOCK) ON CSD.[BarcodeNo] = ASD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CHCShipments] CCS WITH (NOLOCK) ON CCS.[ID] = CSD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_HPLCTestedDetail] HTD  WITH (NOLOCK) ON HTD.[Barcode] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[BarcodeNo] = CSD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HT.[BarcodeNo] = HD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CentralLabShipmentsDetail] CLSD WITH (NOLOCK) ON CLSD.[BarcodeNo] = CSD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CentralLabShipments] CLCS WITH (NOLOCK) ON CLCS.[ID] = CLSD.[ShipmentID]
			WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail]) AND (CTD.[ConfirmationStatus] = 1 OR CTD.[ConfirmationStatus] IS NULL) 
			AND (HTD.[SampleStatus] = 1 OR HTD.[SampleStatus] IS NULL)
			AND (SPRD.[DistrictID] = @DistrictId OR @DistrictId = 0)
			AND (BM.[ID] = @BlockId OR @BlockId = 0)
			AND (SPRD.[CHCID] = @CHCId OR @CHCId = 0) AND(SPRD.[DateofRegister] BETWEEN  @StartDate AND @EndDate)
			)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC

		---------------------ONTIME REGISTRATION ENTRY IN SYSTEM-----------------------------------
			SET @A1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 9)
		
		SET @A2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 9 AND (SubjectCreatedOn <= CBCTestedDate))

		SET @A3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND  RegistrationFrom = 9 AND  ((CONVERT(DATE,DateOfRegister,103) > CONVERT(DATE,CBCTestedDate,103))
					OR (SubjectCreatedOn > CBCTestedDate)))

		SET @A4 = ISNULL((@A2 * 100 )/ NULLIF(@A1,0),0)
		------------------------------------------------------------------

		---------------ONTIME SAMPLES COLLECTED / UPDATED IN SYSTEM--------------------------------------------
		SET @B1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 11)
		
		SET @B2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 11
					AND (CONVERT(DATE,SampleCollectionDateTime,103) <= CONVERT(DATE,CBCTestedDate,103)) AND (SampleCreatedOn <= CBCTestedDate))
		
		SET @B3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 11
					AND ((CONVERT(DATE,SampleCollectionDateTime,103) > CONVERT(DATE,CBCTestedDate,103)) OR (SampleCreatedOn > CBCTestedDate)))

		SET @B4 = ISNULL((@B2 * 100 )/ NULLIF(@B1,0),0)

		---------------------------------------------------------------------


		---------------ONTIME SHIPMENT OF SAMPLES TO TESTING CHC --------------------------------------------
		SET @C1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 5)

		SET @C2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 5
				AND (CONVERT(DATE,ShipmentDateTime,103) <= CONVERT(DATE,CBCTestedDate,103)) AND  (ShipmentCreatedOn <=  CBCTestedDate))

		SET @C3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 5
				AND ((CONVERT(DATE,ShipmentDateTime,103) > CONVERT(DATE,CBCTestedDate,103)) OR  (ShipmentCreatedOn >  CBCTestedDate)))
	
		SET @C4 = ISNULL((@C2 * 100 )/ NULLIF(@C1,0),0)

		---------------------------------------------------------------------

		---------------------D Series -----------------------------------
		SET @D1 = @B1

		SET @D2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND SampleTimeoutExpiry = 1 AND RegistrationFrom = 9)

		SET @D3 = ISNULL((@D2 * 100)/NULLIF(@D1,0),0)
		---------------------------------------------------------------------

		---------------------E Series -----------------------------------
		SET @E1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate))

		SET @E2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,ReceivedDateCreatedOn,103) =  CONVERT(DATE,ShipmentDateTime,103)))

		SET @E3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,ReceivedDateCreatedOn,103) >  CONVERT(DATE,ShipmentDateTime,103)))

		SET @E4 = ISNULL((@E2 * 100)/NULLIF(@E1,0),0)
		---------------------------------------------------------------------

		---------------------F Series ---------------------------------------
		SET @F1 = @E1

		SET @F2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,CBCTestedDate,103) =  CONVERT(DATE,ReceivedDate,103)))

		SET @F3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND ((CONVERT(DATE,CBCTestedDate,103) >  CONVERT(DATE,ReceivedDate,103)) OR (CONVERT(DATE,CBCTestedDate,103) < CONVERT(DATE,CBCTestCreatedOn,103))))

		SET @F4 = ISNULL((@F2 * 100)/NULLIF(@F1,0),0)
		---------------------------------------------------------------------

		---------------------G Series ---------------------------------------
		SET @G1 = @E1

		SET @G2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,SSTCreatedOn,103) =  CONVERT(DATE,ReceivedDate,103)))

		SET @G3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,SSTCreatedOn,103) >  CONVERT(DATE,ReceivedDate,103)))

		SET @G4 = ISNULL((@G2 * 100)/NULLIF(@G1,0),0)
		---------------------------------------------------------------------

		---------------------H Series ---------------------------------------
		SET @H1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CBCResult = 1 OR SSTResult = 1))

		SET @H2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,CHCtoCentralShipmentCreatedOn,103) =  CONVERT(DATE,CBCTestedDate,103)))

		SET @H3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
					AND (CONVERT(DATE,CHCtoCentralShipmentCreatedOn,103) > (CASE WHEN CONVERT(DATE,CBCTestedDate,103) < CONVERT(DATE,SSTCreatedOn,103)  THEN CONVERT(DATE,CBCTestedDate,103) ELSE CONVERT(DATE,SSTCreatedOn,103) END)))

		--SET @H3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) 
		--			AND (CONVERT(DATE,CHCtoCentralShipmentCreatedOn,103) > CONVERT(DATE,CBCTestedDate,103)))

		SET @H4 =ISNULL((@H2 * 100)/NULLIF(@H1,0),0)
		---------------------------------------------------------------------

		---------------------I Series ---------------------------------------
		SET @I1 = @E1

		SET @I2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CHCSampleTimeout= 1)

		SET @I3 = ISNULL((@I2 * 100)/NULLIF(@I1,0),0)
		---------------------------------------------------------------------

		---------------------J Series ---------------------------------------
		SET @J1 = @E1

		SET @J2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CHCSampleDamaged= 1)

		SET @J3 = ISNULL((@J2 * 100)/NULLIF(@J1,0),0)
		---------------------------------------------------------------------

		---------------K Series --------------------------------------------
		SET @K1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate))

		SET @K2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,CHCtoCentralReceivedDateCreatedOn,103) <= CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))

		SET @K3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,CHCtoCentralReceivedDateCreatedOn,103) > CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))

		SET @K4 = ISNULL((@K2 * 100)/NULLIF(@K1,0),0)
		---------------------------------------------------------------------

		---------------L Series --------------------------------------------
		SET @L1 = @K1

		SET @L2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,HPLCTestedDate,103) <= CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))

		SET @L3 =  (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,HPLCTestedDate,103) > CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))
		SET @L4 = ISNULL((@L2 * 100)/NULLIF(@L1,0),0)
		---------------------------------------------------------------------

		---------------M Series --------------------------------------------
		SET @M1 = @K1

		SET @M2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,HPLCTestedDate,103) <= CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))

		SET @M3 =  (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CHCtoCentralShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,HPLCTestedDate,103) > CONVERT(DATE,DATEADD(DAY,4,CHCtoCentralShipmentCreatedOn),103)))

		SET @M4= ISNULL((@M2 * 100)/NULLIF(@M1,0),0)
		---------------------------------------------------------------------

		---------------N Series --------------------------------------------
		SET @N1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE CentraltoMolecularShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate))

		SET @N2 =  (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE  (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND (CONVERT(DATE,CentraltoMolecularShipmentCreatedOn,103) = CONVERT(DATE,HPLCDiagnosisCompletedOn,103)))

		SET @N3 =  (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE   (DateOfRegister BETWEEN @StartDate AND @EndDate)
					AND  (CONVERT(DATE,CentraltoMolecularShipmentCreatedOn,103) > CONVERT(DATE,HPLCDiagnosisCompletedOn,103)))

		SET @N4= ISNULL((@N2 * 100)/NULLIF(@N1,0),0)
		---------------------------------------------------------------------

		---------------O Series --------------------------------------------
		SET @O1  = @K1

		SET @O2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CLLabSampleTimeout= 1)

		SET @O3 = ISNULL((@O2 * 100)/NULLIF(@O1,0),0)
		---------------------------------------------------------------------

		---------------P Series --------------------------------------------
		SET @P1  = @K1

		SET @P2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CLLabSampleDamaged= 1)

		SET @P3 = ISNULL((@P2 * 100)/NULLIF(@P1,0),0)
		---------------------------------------------------------------------

		---------------Q Series --------------------------------------------
		SET @Q1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND HPLCSampleStatus = 1)

		SET @Q2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND HPLCDiagnosisComplete = 1
					AND (CONVERT(DATE,HPLCDiagnosisCompletedOn,103) <=  CONVERT(DATE,DATEADD(DAY,1,HPLCTestConfirmationOn),103)))

		SET @Q3 =  (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND HPLCDiagnosisComplete = 1
					AND (CONVERT(DATE,HPLCDiagnosisCompletedOn,103) >  CONVERT(DATE,DATEADD(DAY,1,HPLCTestConfirmationOn),103)))

		SET @Q4= ISNULL((@Q2 * 100)/NULLIF(@Q1,0),0)
		---------------------------------------------------------------------

		SELECT 	@A1 AS A1, @A2 AS A2, @A3 AS A3, @A4 AS A4, @B1 As B1,@B2 AS B2, @B3 AS B3, @B4 AS B4
				, @C1 AS C1, @C2 AS C2, @C3 AS C3, @C4 AS C4, @D1 AS D1, @D2 AS D2, @D3 AS D3, @E1 AS E1, @E2 AS E2, @E3 AS E3,@E4 AS E4
				, @F1 AS F1, @F2 AS F2, @F3 AS F3, @F4 AS F4, @G1 AS G1, @G2 AS G2, @G3 AS G3, @G4 AS G4, @H1 AS H1, @H2 AS H2, @H3 AS H3, @H4 AS H4
				, @I1 AS I1, @I2 AS I2, @I3 AS I3, @J1 AS J1, @J2 AS J2, @J3 AS J3
				, @K1 AS K1, @K2 AS K2, @K3 AS K3, @K4 AS K4, @L1 AS L1, @L2 AS L2, @L3 AS L3, @L4 AS L4, @M1 AS M1, @M2 AS M2, @M3 AS M3,@M4 AS M4
				, @N1 AS N1, @N2 AS N2, @N3 AS N3, @N4 AS N4, @O1 AS O1, @O2 AS O2, @O3 AS O3, @P1 AS P1, @P2 AS P2, @P3 AS P3
				, @Q1 AS Q1, @Q2 AS Q2, @Q3 AS Q3, @Q4 AS Q4
		--SELECT  * FROM #TempANMCompaileanceRepTable
END