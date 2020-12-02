--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCompailancePerformanceMetrics' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCompailancePerformanceMetrics  --'24/11/2020','25/11/2020',0,0,0,0,0,0
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCompailancePerformanceMetrics] 
(
	@FromDate VARCHAR(200)
	,@ToDate VARCHAR(200)
	,@DistrictId INT
	,@BlockId INT
	,@CHCId INT
	,@PHCId INT
	,@SCId INT
	,@ANMId INT
)

AS
	DECLARE @StartDate DATETIME, @EndDate DATETIME, @EndDateTime VARCHAR(100)
	DECLARE @A1 INT, @A2 INT, @A3 INT, @A4 INT, @A5 INT, @A6 INT, @A7 INT 
			,@B1 INT, @B2 INT, @B3 INT, @B4 INT, @B5 INT, @B6 INT, @B7 INT
			,@C1 INT, @C2 INT, @C3 INT, @C4 INT, @C5 INT, @C6 INT, @C7 INT
			,@D1 INT, @D2 INT, @D3 INT
			,@E1 INT, @E2 INT, @E3 INT
			,@F1 INT, @F2 INT, @F3 INT
			,@G1 INT, @G2 INT, @G3 INT
			,@H1 INT, @H2 INT, @H3 INT
			,@I1 INT, @I2 INT, @I3 INT
			,@J1 INT, @J2 INT, @J3 INT
			,@K INT, @L INT, @M INT
BEGIN
	SET @StartDate = CONVERT(DATETIME,@FromDate,103)
	SET @EndDateTime = @ToDate + ' 23:59:59'
	SET @EndDate = CONVERT(DATETIME,@EndDateTime,103)
	Print @EndDate

	CREATE  TABLE #TempANMCompaileanceRepTable(ID INT IDENTITY(1,1), UniqueSubjectID VARCHAR(500), DateOfRegister DATETIME, SubjectCreatedOn DATETIME, RegistrationFrom INT,
	 SamplingStatus BIT, Barcode VARCHAR(200),SampleCollectionDate DATE, SampleCollectionTime TIME(2), SampleCollectionDateTime DATETIME, SampleCreatedOn DATETIME,CollectionFrom INT,SampleTimeoutExpiry BIT,SampleDamaged BIT,
	 ShipmentStatus BIT, ShipmentFrom INT, DateOfShipment DATETIME,  TimeOfShipment TIME(2), ShipmentDateTime DATETIME, ShipmentCreatedOn DATETIME, ReceivedDate DATETIME, ReceivedDateCreatedOn DATETIME,
	 CBCTestStatus BIT,CBCTestedDate DATETIME, CBCTestCreatedOn DATETIME,
	 [ROW NUMBER] INT)

	 INSERT INTO #TempANMCompaileanceRepTable(UniqueSubjectID, DateOfRegister, SubjectCreatedOn, RegistrationFrom,
	 SamplingStatus, Barcode,SampleCollectionDate, SampleCollectionTime, SampleCollectionDateTime, SampleCreatedOn,CollectionFrom,SampleTimeoutExpiry,SampleDamaged,
	 ShipmentStatus, ShipmentFrom, DateOfShipment, TimeOfShipment, ShipmentDateTime, ShipmentCreatedOn, ReceivedDate, ReceivedDateCreatedOn,
	 CBCTestStatus,CBCTestedDate, CBCTestCreatedOn,
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
				,CASE WHEN CTD.[ID] IS NULL THEN 0 ELSE 1 END CBCTestDone
				,CTD.[TestedDateTime] AS CBCTestedDate
				,CTD.[CreatedOn] AS CBCTestCreatedOn
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_SubjectPrimaryDetail] AS SPRD
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectParentDetail] SPAD WITH (NOLOCK) ON SPAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SPAD.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipmentsDetail] ASD WITH (NOLOCK) ON ASD.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_ANMCHCShipments] ACS WITH (NOLOCK) ON ACS.[ID] = ASD.[ShipmentID]
			LEFT JOIN [dbo].[Tbl_CBCTestedDetail] CTD  WITH (NOLOCK) ON CTD.[Barcode] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SPRD.[CHCID]
			LEFT JOIN [dbo].[Tbl_BlockMaster] BM WITH (NOLOCK) ON BM.[ID] = CM.[BlockID]
			WHERE  SPRD.[ID] IN (SELECT SubjectID FROM [dbo].[Tbl_SubjectParentDetail]) 
			AND (CTD.[ConfirmationStatus] = 1 OR CTD.[ConfirmationStatus] IS NULL OR CTD.[ConfirmationStatus] = 2)
			AND (SPRD.[DistrictID] = @DistrictId OR @DistrictId = 0)
			AND (BM.[ID] = @BlockId OR @BlockId = 0)
			AND (SPRD.[CHCID] = @CHCId OR @CHCId = 0)
			AND (SPRD.[SCID] = @SCId OR @SCId = 0)
			AND (SPRD.[AssignANM_ID] = @ANMId OR @ANMId = 0) 
			AND (SPRD.[RegisteredFrom] = 8) AND ( SPRD.[DateofRegister] BETWEEN  @StartDate AND @EndDate)
			)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC

		---------------------Subject Registration Series ---------------------------------------------------------------------------------------
		SET @A1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 8)
		
		SET @A2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 8 AND (SubjectCreatedOn <= CBCTestedDate))

		SET @A3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND  RegistrationFrom = 8 AND  ((CONVERT(DATE,DateOfRegister,103) > CONVERT(DATE,CBCTestedDate,103))
					OR (SubjectCreatedOn > CBCTestedDate)))

		SET @A4 = ISNULL((@A2 * 100 )/ NULLIF(@A1,0),0)

		SET @A5 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND (CONVERT(DATE,SubjectCreatedOn,103) = CONVERT(DATE,DateOfRegister,103)) 
					AND RegistrationFrom = 8)

		SET @A6 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate)AND RegistrationFrom = 8 AND ((CONVERT(DATE,SubjectCreatedOn,103) > CONVERT(DATE,DateOfRegister,103))
					OR (SubjectCreatedOn > CBCTestedDate)) )

		SET @A7 = ISNULL((@A5 * 100 )/ NULLIF(@A1,0),0)
		------------------------------------------------------------------------------------------------------------------------------------------

		---------------Sample Collection Series --------------------------------------------------------------------------------------------------
		SET @B1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10)
		
		SET @B2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10
					AND (CONVERT(DATE,SampleCollectionDateTime,103) <= CONVERT(DATE,CBCTestedDate,103)) AND (SampleCreatedOn <= CBCTestedDate))
		
		SET @B3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10
					AND ((CONVERT(DATE,SampleCollectionDateTime,103) > CONVERT(DATE,CBCTestedDate,103)) OR (SampleCreatedOn > CBCTestedDate)))

		SET @B4 = ISNULL((@B2 * 100 )/ NULLIF(@B1,0),0)

		SET @B5 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10
					AND  (CONVERT(DATE,SampleCreatedOn,103) = CONVERT(DATE,SampleCollectionDateTime,103)))

		SET @B6 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10
					AND  ((CONVERT(DATE,SampleCreatedOn,103) > CONVERT(DATE,SampleCollectionDateTime,103)) OR (SampleCreatedOn > CBCTestedDate)))

		SET @B7 = ISNULL((@B5 * 100 )/ NULLIF(@B1,0),0)
		-----------------------------------------------------------------------------------------------------------------------------------------

		---------------Shipment Series-----------------------------------------------------------------------------------------------------------
		SET @C1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4)

		SET @C2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4
				AND (CONVERT(DATE,ShipmentDateTime,103) <= CONVERT(DATE,CBCTestedDate,103)) AND  (ShipmentCreatedOn <=  CBCTestedDate))

		SET @C3 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4
				AND ((CONVERT(DATE,ShipmentDateTime,103) > CONVERT(DATE,CBCTestedDate,103)) OR  (ShipmentCreatedOn >  CBCTestedDate)))
	
		SET @C4 = ISNULL((@C2 * 100 )/ NULLIF(@C1,0),0)

		SET @C5 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4
				AND (CONVERT(DATE,ShipmentCreatedOn,103) = CONVERT(DATE,ShipmentDateTime,103)))

		SET @C6 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4
				AND ((CONVERT(DATE,ShipmentCreatedOn,103) > CONVERT(DATE,ShipmentDateTime,103)) OR (ShipmentCreatedOn >  CBCTestedDate)))

		SET @C7 = ISNULL((@C5 * 100 )/ NULLIF(@C1,0),0)
		--------------------------------------------------------------------------------------------------------------------------------------

		---------------------Incorrect Entry of Registration Date-----------------------------------------------------------------------------
		SET @D1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 8)

		SET @D2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND RegistrationFrom = 8 
			AND (CONVERT(DATE,DateOfRegister,103) > CONVERT(DATE,CBCTestedDate,103)))

		SET @D3 = ISNULL((@D2 * 100)/NULLIF(@D1,0),0)
		----------------------------------------------------------------------------------------------------------------------------------------

		---------------------Incorrect Entry of Sample Collection Date / Time (Greater than Sample Testing Date / Time )------------------------
		SET @E1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10)

		SET @E2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE SamplingStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND CollectionFrom = 10
					AND SampleCollectionDateTime > CBCTestedDate)

		SET @E3 = ISNULL((@E2 * 100)/NULLIF(@E1,0),0)
		-----------------------------------------------------------------------------------------------------------------------------------------

		----------------Incorrect Entry of Sample Shipment Date / Time (Greater than Sample Testing Date / Time )--------------------------------
		SET @F1 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4)

		SET @F2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE ShipmentStatus=1 AND  (DateOfRegister BETWEEN @StartDate AND @EndDate) AND ShipmentFrom = 4
					AND ShipmentDateTime  > CBCTestedDate)

		SET @F3 = ISNULL((@F2 * 100)/NULLIF(@F1,0),0)
		-------------------------------------------------------------------------------------------------------------------------------------------

		---------------------Samples Time Out-----------------------------------------------------------------------------------------------------
		SET @G1 = @E1

		SET @G2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND SampleTimeoutExpiry = 1 AND RegistrationFrom = 8)

		SET @G3 = ISNULL((@G2 * 100)/NULLIF(@G1,0),0)
		-------------------------------------------------------------------------------------------------------------------------------------------

		---------------------Damaged Samples + Clot Blood------------------------------------------------------------------------------------------
		SET @H1 = @E1

		SET @H2 = (SELECT COUNT(1) FROM #TempANMCompaileanceRepTable WHERE (DateOfRegister BETWEEN @StartDate AND @EndDate) AND SampleDamaged = 1 AND RegistrationFrom = 8)

		SET @H3 = ISNULL((@H2 * 100)/NULLIF(@H1,0),0)
		--------------------------------------------------------------------------------------------------------------------------------------------
		
		---------------------Registration Data Completeness Index-----------------------------------------------------------------------------------
		SET @I1 = @D1
		SET @I2 = (SELECT COUNT(1) FROM Tbl_SubjectPrimaryDetail SP
					LEFT JOIN Tbl_SubjectAddressDetail SA WITH (NOLOCK) ON SA.SubjectID = SP.ID
					LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
					WHERE SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail) 
					AND SA.Religion_Id > 0 AND SA.Caste_Id > 0 AND ISNULL(ECNumber,'')<> '' AND SP.RegisteredFrom = 8 AND (SP.DateOfRegister BETWEEN @StartDate AND @EndDate))
		SET @I3 = ISNULL((@I2 * 100)/NULLIF(@I1,0),0)
		---------------------------------------------------------------------------------------------------------------------------------------------

		---------------------Overall Registration Data Completeness Index----------------------------------------------------------------------------
		DECLARE @J INT
		SET @J1 = (@D1 * 20 )
		SET @J = (SELECT((SELECT COUNT(1) FROM Tbl_SubjectPrimaryDetail SP LEFT JOIN Tbl_SubjectAddressDetail SA WITH (NOLOCK) ON SA.SubjectID = SP.ID LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
					WHERE SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail) AND SA.Religion_Id = 0 AND SP.RegisteredFrom = 8 AND (SP.DateOfRegister BETWEEN @StartDate AND @EndDate)) +
					(SELECT COUNT(1) FROM Tbl_SubjectPrimaryDetail SP LEFT JOIN Tbl_SubjectAddressDetail SA WITH (NOLOCK) ON SA.SubjectID = SP.ID LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
					WHERE SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail) AND SA.Caste_Id = 0 AND SP.RegisteredFrom = 8 AND (SP.DateOfRegister BETWEEN @StartDate AND @EndDate)) + 
					(SELECT COUNT(1) FROM Tbl_SubjectPrimaryDetail SP LEFT JOIN Tbl_SubjectAddressDetail SA WITH (NOLOCK) ON SA.SubjectID = SP.ID LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.SubjectID = SP.ID
					WHERE SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail) AND ISNULL(ECNumber,'') = '' AND SP.RegisteredFrom = 8 AND (SP.DateOfRegister BETWEEN @StartDate AND @EndDate))))
		SET @J2 = @J1 - @J
		SET @J3 = ISNULL((@J2 * 100)/NULLIF(@J1,0),0)
		--------------------------------------------------------------------------------------------------------------------------------------------

		---------------------ANM Detail Series------------------------------------------------------------------------------------------------------
		SET @K = (SELECT COUNT(1) FROM Tbl_ANMDetail)

		SET @L = (SELECT COUNT(DISTINCT(AssignANM_ID)) FROM Tbl_SubjectPrimaryDetail SP 
					LEFT JOIN TBL_UserMaster UM WITH (NOLOCK) ON UM.ID = SP.AssignANM_ID
					WHERE SP.DateofRegister    BETWEEN @StartDate AND @EndDate AND UM.UserRole_ID = 3)

		SET @M = (Select COUNT(DISTINCT(Barcode)) FROM Tbl_CBCTestedDetail  WHERE Barcode <>'INVALID' AND Barcode NOT LIKE 'AUTO%' AND CreatedOn BETWEEN @StartDate AND @EndDate )
		------------------------------------------------------------------------------------------------------------------------------------------------

		SELECT 	@A1 AS A1, @A2 AS A2, @A3 AS A3, @A4 AS A4, @A5 AS A5, @A6 AS A6, @A7 AS A7,@B1 As B1,@B2 AS B2, @B3 AS B3, @B4 AS B4, @B5 B5, @B6 AS B6, @B7 B7
				, @C1 AS C1, @C2 AS C2, @C3 AS C3, @C4 AS C4, @C5 AS C5, @C6 AS C6, @C7 AS C7, @D1 AS D1, @D2 AS D2, @D3 AS D3, @E1 AS E1, @E2 AS E2, @E3 AS E3
				, @F1 AS F1, @F2 AS F2, @F3 AS F3, @G1 AS G1, @G2 AS G2, @G3 AS G3, @H1 AS H1, @H2 AS H2, @H3 AS H3, @I1 AS I1, @I2 AS I2, @I3 AS I3, @J1 AS J1, @J2 AS J2, @J3 AS J3
				, @K AS K, @L AS L, @M AS M
		--SELECT  * FROM #TempANMCompaileanceRepTable
		-------------------------------------------------------------------------------------------------------------------------------------------------
END