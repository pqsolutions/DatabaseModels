--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SrPathoDiagnosisReport' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SrPathoDiagnosisReport 
END
GO
CREATE PROCEDURE [dbo].[SPC_SrPathoDiagnosisReport]
(
	@FromDate VARCHAR(50)
	,@ToDate VARCHAR(50)
	,@SubjectType INT
	,@CentralLabID INT
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

	CREATE  TABLE #TempReportDetail(ID INT IDENTITY(1,1),  
	UniqueSubjectId VARCHAR(250),  SubjectName VARCHAR(MAX), SubjectType VARCHAR(150), Contact VARCHAR(250), Barcode VARCHAR(150), GA VARCHAR(100), 
	ScreeningResults VARCHAR(MAX), HPLCResults VARCHAR(MAX), LaboratoryDiagnosis VARCHAR(MAX),[ROW NUMBER] INT) 
	IF @Status = 1
	BEGIN
		INSERT INTO #TempReportDetail (UniqueSubjectId,  SubjectName , SubjectType , Contact , Barcode, GA, ScreeningResults , HPLCResults, LaboratoryDiagnosis ,[ROW NUMBER])
		SELECT * FROM (
			SELECT SPRD.[UniqueSubjectID]
				,(SPRD.[FirstName] + ' ' + SPRD.[LastName]) AS SubjectName
				,ST.[SubjectType]
				,SPRD.[MobileNo]
				,HT.[BarcodeNo]
				,CASE WHEN  SPRD.[ChildSubjectTypeID] = 1 THEN  
				(SELECT [dbo].[FN_CalculateGAonHPLCDate](SPRD.[ID], HT.[BarcodeNo])) ELSE '' END  AS GA
				,CASE WHEN SST.[IsPositive] =  1 THEN 'CBC: '+ CBC.[CBCResult] +', SST: SST Positive' ELSE 'CBC: '+ CBC.[CBCResult] +', SST: SST Negative' END  AS ScreeningResults
				,HT.[HPLCResult]
				,HT.[LabDiagnosis]
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_HPLCTestResult] HT   
			LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = HT.[BarcodeNo] 
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[BarcodeNo] = HD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.[BarcodeNo] = HT.[BarcodeNo]  
			LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = HT.[BarcodeNo] 
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SPRD   WITH (NOLOCK) ON SPRD.[UniqueSubjectID] = SC.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SPRD.[ChildSubjectTypeID]
			WHERE  HT.[CentralLabId] = @CentralLabID   
			AND HT.[BarcodeNo]  IN (SELECT BarcodeNo FROM Tbl_HPLCDiagnosisResult)  
			AND (@CHCID  = 0 OR SPRD.[CHCID] = @CHCID)   
			AND (@PHCID  = 0 OR SPRD.[PHCID] = @PHCID)   
			AND (@ANMID  = 0 OR SPRD.[AssignANM_ID] = @ANMID)   
			AND HD.[IsDiagnosisComplete] = 1  
			AND HD.[IsConsultSeniorPathologist] = 1
			AND (CONVERT(DATE,HT.[HPLCResultUpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC
	END
	IF @Status = 2
	BEGIN
		INSERT INTO #TempReportDetail (UniqueSubjectId,  SubjectName , SubjectType , Contact , Barcode, GA, ScreeningResults , HPLCResults, LaboratoryDiagnosis ,[ROW NUMBER])
		SELECT * FROM (
			SELECT SPRD.[UniqueSubjectID]
				,(SPRD.[FirstName] + ' ' + SPRD.[LastName]) AS SubjectName
				,ST.[SubjectType]
				,SPRD.[MobileNo]
				,HT.[BarcodeNo]
				,CASE WHEN  SPRD.[ChildSubjectTypeID] = 1 THEN  
				(SELECT [dbo].[FN_CalculateGAonHPLCDate](SPRD.[ID], HT.[BarcodeNo])) ELSE '' END  AS GA
				,CASE WHEN SST.[IsPositive] =  1 THEN 'CBC: '+ CBC.[CBCResult] +', SST: SST Positive' ELSE 'CBC: '+ CBC.[CBCResult] +', SST: SST Negative' END  AS ScreeningResults
				,HT.[HPLCResult]
				,HT.[LabDiagnosis]
				,ROW_NUMBER() OVER (PARTITION BY SPRD.[UniqueSubjectID]  ORDER BY SC.[CreatedOn] DESC) AS [ROW NUMBER]
			FROM [dbo].[Tbl_HPLCTestResult] HT   
			LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.[BarcodeNo] = HT.[BarcodeNo] 
			LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[BarcodeNo] = HD.[BarcodeNo]
			LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.[BarcodeNo] = HT.[BarcodeNo]  
			LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = HT.[BarcodeNo] 
			LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SPRD   WITH (NOLOCK) ON SPRD.[UniqueSubjectID] = SC.[UniqueSubjectID] 
			LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.[ID] = SPRD.[ChildSubjectTypeID]
			WHERE  HT.[CentralLabId] = @CentralLabID   
			AND HT.[BarcodeNo]  IN (SELECT BarcodeNo FROM Tbl_HPLCDiagnosisResult)  
			AND (@CHCID  = 0 OR SPRD.[CHCID] = @CHCID)   
			AND (@PHCID  = 0 OR SPRD.[PHCID] = @PHCID)   
			AND (@ANMID  = 0 OR SPRD.[AssignANM_ID] = @ANMID)   
			AND HD.[IsDiagnosisComplete] = 0  
			AND HD.[IsConsultSeniorPathologist] = 1
			AND (CONVERT(DATE,HT.[HPLCResultUpdatedOn],103) BETWEEN CONVERT(DATE,@StartDate,103) AND CONVERT(DATE,@EndDate,103)) 
		)GROUPS
		WHERE GROUPS.[ROW NUMBER] = 1 
		ORDER BY GROUPS.UniqueSubjectID ASC
	END

	SELECT * FROM #TempReportDetail

	DROP TABLE #TempReportDetail
END