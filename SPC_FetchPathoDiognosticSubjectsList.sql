USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchPathoDiognosticSubjectsList' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchPathoDiognosticSubjectsList
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchPathoDiognosticSubjectsList]
(
	@CentralLabId INT
)AS
BEGIN
	SELECT SPRD.[UniqueSubjectID]
			,SPRD.[DistrictID]
			,DM.[Districtname] AS District
			,SPRD.[CHCID]
			,C.[CHCname] AS TestingCHC
			,SPRD.[RIID]
			,RM.[RIsite] AS RIPoint
			,SPRD.[Age] 
			,SPRD.[Gender]
			,HR.[BarcodeNo] 
			,(SPRD.[SubjectTitle] +' '+SPRD.[FirstName] + ' ' + SPRD.[MiddleName] + ' ' + SPRD.[LastName]) AS SubjectName
			,SPRD.[MobileNo] AS ContactNo
			,(SPRD.[Spouse_FirstName]+ ' ' + SPRD.[Spouse_MiddleName] + ' ' + SPRD.[Spouse_LastName])AS SpouseName
			,SPRD.[Spouse_ContactNo] AS SpouseContact
			,(SAD.[Address1] + ' , ' + SAD.[Address2] + ' , ' + SAD.[Address3]) SubjectAddress
			,SPD.[RCHID]
			,CASE WHEN (SPD.[LMP_Date] = '' OR SPD.[LMP_Date] IS NULL)  THEN NULL ELSE CONVERT(VARCHAR,SPD.[LMP_Date],103) END AS LMPDate
			,CASE WHEN SPRD.[SubjectTypeID] != 1 AND  SPRD.[ChildSubjectTypeID] = 1 THEN NULL ELSE
			('G'+CONVERT(VARCHAR,SPD.[G])+'-P'+CONVERT(VARCHAR,SPD.[P])+'-L'+CONVERT(VARCHAR,SPD.[L])+'-A'+
			CONVERT(VARCHAR,SPD.[A]))END AS ObstetricsScore
			,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPRD.[ID]))) AS [GestationalAge]
			,CASE WHEN SST.[IsPositive] = 1 THEN 'Positive' ELSE 'Negative' END  SSTResult
			,CBC.[CBCResult] AS [CBCResult]
			,CBC.[MCV]  AS [MCV]
			,CBC. [RDW] AS [RDW]
			,CBC. [RBC] AS [RBC]
			,HR.[HbA0]
			,HR.[HbA2]
			,HR.[HbC]
			,HR.[HbD]
			,HR.[HbF]
			,HR.[HbS]
			,HR.[IsNormal]
			,HR.[ID] AS HPLCTestResultId 
			,(CONVERT(VARCHAR,HR.[HPLCTestCompletedOn],103)) AS DateofTest
	FROM [dbo].[Tbl_HPLCTestResult]  HR
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SPRD WITH (NOLOCK) ON HR.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectAddressDetail] SAD WITH (NOLOCK) ON SAD.[UniqueSubjectID] = SPRD.[UniqueSubjectID] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPRD.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.[BarcodeNo]  = HR.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_SSTestResult] SST WITH (NOLOCK) ON SST.[BarcodeNo] = HR.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_CBCTestResult] CBC WITH (NOLOCK) ON CBC.[BarcodeNo] = HR.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SPRD.[DistrictID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SPRD.[CHCID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.[ID]  = CM.[TestingCHCID] 
	LEFT JOIN [dbo].[Tbl_RIMaster] RM WITH (NOLOCK) ON RM.[ID] = SPRD.[RIID]  
	WHERE  HR.[CentralLabId] = @CentralLabId  AND HR.[ID] NOT IN (SELECT HPLCTestResultId FROM Tbl_HPLCDiagnosisResult)
	ORDER BY [GestationalAge] DESC
END