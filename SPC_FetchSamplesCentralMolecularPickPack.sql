--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSamplesCentralMolecularPickPack' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSamplesCentralMolecularPickPack  --1
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSamplesCentralMolecularPickPack] 
(
	@CentralLabId INT
)
AS
BEGIN

	DECLARE   @Indexvar INT, @TotalCount INT,@SpouseSubjectId VARCHAr(250),@UniqueSubjectId VARCHAr(250)

	CREATE  TABLE #TempUniqueSubjectID(ID INT IDENTITY(1,1),[UniqueSubjectId] VARCHAR(250),[GA] VARCHAR(20)) 

	INSERT INTO #TempUniqueSubjectID([UniqueSubjectId],[GA])
	SELECT SP.[UniqueSubjectId]
			,(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) AS GA
	FROM  Tbl_HPLCDiagnosisResult HD
	LEFT JOIN Tbl_HPLCTestResult HT WITH (NOLOCK) ON HT.BarcodeNo = HD.BarcodeNo
	LEFT JOIN Tbl_SampleCollection SC WITH (NOLOCK) ON SC.BarcodeNo = HD.BarcodeNo
	LEFT JOIN Tbl_SubjectPrimaryDetail SP WITH (NOLOCK) ON SP.UniqueSubjectID = SC.UniqueSubjectID
	WHERE SP.ChildSubjectTypeID = 1 AND SP.ID IN (SELECT SubjectID FROM Tbl_SubjectParentDetail)
	AND HD.[BarcodeNo] IN (SELECT BarcodeNo FROM Tbl_SampleCollection WHERE SampleDamaged != 1 AND SampleTimeoutExpiry != 1)
	AND HD.IsDiagnosisComplete = 1 AND HD.IsNormal = 0 AND LEN(SP.SpouseSubjectID) > 0 
	AND SP.SpouseSubjectID IN (SELECT UniqueSubjectID FROM Tbl_HPLCDiagnosisResult WHERE  IsDiagnosisComplete = 1 AND IsNormal = 0)
	AND HT.CentralLabId  = @CentralLabId AND HT.IsPositive = 1 
	AND HT.BarcodeNo NOT IN (SELECT BarcodeNo FROM Tbl_CentralLabShipmentsDetail) ORDER BY GA DESC

	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1),  UniqueSubjectID VARCHAR(250),  SpouseSubjectId  VARCHAR(250), SubjectType VARCHAR(250),
	SampleCollectionID INT, SubjectName VARCHAR(MAX), SpouseName VARCHAR(MAX), RCHID VARCHAR(250), BarcodeNo VARCHAR(150), SpouseBarcodeNo VARCHAR(150),
	SampleDateTime VARCHAR(250), GestationalAge VARCHAR(10), HPLCResult VARCHAR(MAX), [ROW NUMBER] INT)

	SELECT @TotalCount = COUNT(1) FROM #TempUniqueSubjectID
	SET @IndexVar = 0  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT  @UniqueSubjectId = UniqueSubjectId FROM #TempUniqueSubjectID  WHERE ID = @Indexvar
		SELECT @SpouseSubjectId = SpouseSubjectId FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectId = @UniqueSubjectId

		INSERT INTO #TempReportDetail(UniqueSubjectID, SpouseSubjectId, SubjectType, SampleCollectionID, SubjectName, SpouseName, RCHID, BarcodeNo, 
		SpouseBarcodeNo, SampleDateTime, GestationalAge, HPLCResult,  [ROW NUMBER])
		SELECT * FROM (
		SELECT SP.[UniqueSubjectID]
			,SP.[SpouseSubjectID]
			,ST.[SubjectType]
			,SC.[ID] AS SampleCollectionID
			,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
			,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName
			,SPD.[RCHID] 
			,SC.[BarcodeNo]
			,SSC.[BarcodeNo] AS SpouseBarcodeNo
			,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
			,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPD.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
			,HT.[HPLCResult] 
			,ROW_NUMBER() OVER (PARTITION BY SP.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
		FROM Tbl_SubjectPrimaryDetail SP
		LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
		LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SP.[UniqueSubjectID]
		LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID]
		LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID]
		LEFT JOIN [dbo].[Tbl_SampleCollection] SSC WITH (NOLOCK) ON SSC.[UniqueSubjectID] = SP.[SpouseSubjectID] AND SSC.[SampleDamaged] = 0 AND  SSC.[SampleTimeoutExpiry] = 0
		LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[BarcodeNo] = SC.[BarcodeNo]
		LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = SC.[BarcodeNo] AND HD.[IsDiagnosisComplete] = 1
		WHERE SP.[UniqueSubjectID] = @UniqueSubjectId 
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		IF LEN(@SpouseSubjectId) > 0 
		BEGIN
			INSERT INTO #TempReportDetail(UniqueSubjectID,  SpouseSubjectId, SubjectType, SampleCollectionID, SubjectName, SpouseName, RCHID, BarcodeNo, 
			SpouseBarcodeNo, SampleDateTime, GestationalAge, HPLCResult,  [ROW NUMBER])
			SELECT * FROM (
			SELECT SP.[UniqueSubjectID]
				,SP.[SpouseSubjectID]
				,ST.[SubjectType]
				,SC.[ID] AS SampleCollectionID
				,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
					,(SP.[Spouse_FirstName] + ' ' + SP.[Spouse_MiddleName] + ' ' + SP.[Spouse_LastName]) AS SpouseName
				,SPD.[RCHID] 
				,SC.[BarcodeNo]
				,SSC.[BarcodeNo] AS SpouseBarcodeNo
				,(CONVERT(VARCHAR,SC.[SampleCollectionDate],103) + ' ' + CONVERT(VARCHAR(5),SC.[SampleCollectionTime])) AS SampleDateTime
				,'--' AS GestationalAge
				,HT.[HPLCResult] 
				,ROW_NUMBER() OVER (PARTITION BY SP.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM Tbl_SubjectPrimaryDetail SP
			LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SP.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SP.[ChildSubjectTypeID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[UniqueSubjectID] = SP.[UniqueSubjectID]
			LEFT JOIN [dbo].[Tbl_SampleCollection] SSC WITH (NOLOCK) ON SSC.[UniqueSubjectID] = SP.[SpouseSubjectID] AND SSC.[SampleDamaged] = 0 AND  SSC.[SampleTimeoutExpiry] = 0
			LEFT JOIN [dbo].[Tbl_HPLCTestResult] HT WITH (NOLOCK) ON HT.[BarcodeNo] = SC.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = SC.[BarcodeNo] AND HD.[IsDiagnosisComplete] = 1
			WHERE SP.[UniqueSubjectID] = @SpouseSubjectId 
			)GROUPS
			WHERE GROUPS.[ROW NUMBER] = 1 
		END
	END
	
	SELECT * FROM #TempReportDetail 
	DROP Table #TempUniqueSubjectID
	DROP Table #TempReportDetail
END