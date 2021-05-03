--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsForMolecularBloodTestEdit' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsForMolecularBloodTestEdit 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsForMolecularBloodTestEdit] 
(
	@MolecularLabId INT
)
AS
BEGIN
	SELECT SP.[ID] AS SubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' '+ SP.[LastName] ) AS SubjectName
		,MSTR.[UniqueSubjectID]
		,ST.[SubjectType] 
		,ISNULL(SPR.[RCHID] ,'') AS RCHID
		,SP.[Age] 
		,SP.[Gender] 
		,CASE WHEN ISNULL(SP.[DOB],'') = '' THEN '' ELSE CONVERT(VARCHAR,SP.[DOB],103) END DOB
		,SP.[MobileNo] AS ContactNo
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
			CONVERT(VARCHAR,SPR.[LMP_Date],103) ELSE '' END AS LMPDate
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		(SELECT [dbo].[FN_CalculateGestationalAge](SP.[ID])) ELSE '' END AS GestationalAge
		,CASE WHEN SP.[SubjectTypeID] = 1 OR SP.[ChildSubjectTypeID] = 1 THEN
		 ('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		 CONVERT(VARCHAR,SPR.[A])) ELSE '' END AS ObstetricScore
		,ISNULL(SPR.[ECNumber],'') AS ECNumber
		,MSTR.[BarcodeNo]
		,DM.[Districtname]
		,CR.[MCV] 
		,CR.[RDW]
		,CR.[RBC]
		,PRSD.[CBCResult] 
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SSTResult
		,PRSD.[HPLCTestResult]
		,HR.[HbA0]
		,HR.[HbA2] 
		,HR.[HbC]
		,HR.[HbD]
		,HR.[HbF]
		,HR.[HbS] 
		,HR.[LabDiagnosis] AS HPLCDiagnosis
		,ISNULL(MSTR.[IsDamaged],0) AS SampleDamaged
		,ISNULL(MSTR.[IsProcessed],0) AS SampleProcessed
		,MSTR.[ZygosityId]
		,MSTR.[Mutation1Id]
		,MSTR.[Mutation2Id]
		,MSTR.[Mutation3]
		,MSTR.[TestResult]
		,MSTR.[ReasonForClose]
		,CONVERT(VARCHAR,MSTR.[TestDate],103) AS TestDate

		,PRSDS.[UniqueSubjectID] AS SpouseSubectId
		,(SPDS.[FirstName] + ' ' +SPDS.[LastName] ) AS SpouseName
		,PRSDS.[CBCResult] AS SpouseCBCResult
		,CASE WHEN PRSDS.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,PRSDS.[HPLCTestResult] AS SpouseHPLCResult

		,SCTR.[MCV] AS Spouse_MCV
		,SCTR.[RDW] AS Spouse_RDW
		,SCTR.[RBC] AS Spouse_RBC

		,SHTR.[HbF] AS Spouse_HbF
		,SHTR.[HbS] AS Spouse_HbS
		,SHTR.[HbD] AS Spouse_HbD
		,SHTR.[HbA0] AS Spouse_HbA0
		,SHTR.[HbA2] AS Spouse_HbA2

	FROM [dbo].[Tbl_MolecularBloodTestResult] MSTR
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP   WITH (NOLOCK) ON SP.UniqueSubjectID = MSTR.UniqueSubjectID
	LEFT JOIN Tbl_SubjectPrimaryDetail SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = SP.[SpouseSubjectID]
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail] SPR   WITH (NOLOCK) ON SPR.UniqueSubjectID = MSTR.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_SubjectTypeMaster] ST WITH (NOLOCK) ON ST.ID = SP.[ChildSubjectTypeID] 
	LEFT JOIN [dbo].[Tbl_SampleCollection] SC WITH (NOLOCK) ON SC.BarcodeNo = MSTR.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK)ON  DM.ID = SP.DistrictID
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.BarcodeNo = MSTR.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSDS WITH (NOLOCK) ON SPDS.UniqueSubjectID = PRSDS.UniqueSubjectID
	LEFT JOIN [dbo].[Tbl_CBCTestResult] CR WITH (NOLOCK) ON CR.BarcodeNo = MSTR.BarcodeNo 
	LEFT JOIN Tbl_CBCTestResult SCTR WITH (NOLOCK) ON SCTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_SSTestResult] SR WITH (NOLOCK) ON SR.BarcodeNo = MSTR.BarcodeNo 
	LEFT JOIN [dbo].[Tbl_HPLCTestResult] HR WITH (NOLOCK) ON HR.BarcodeNo = MSTR.BarcodeNo 
	LEFT JOIN Tbl_HPLCTestResult SHTR WITH (NOLOCK) ON SHTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN [dbo].[Tbl_HPLCDiagnosisResult] HD WITH (NOLOCK) ON HD.BarcodeNo = MSTR.BarcodeNo 
	WHERE MSTR.[MolecularLabId] = @MolecularLabId AND MSTR.[IsComplete] = 0
	AND  PRSD.[HPLCStatus] = 'P' AND PRSD.[IsActive] = 1 AND PRSDS.[HPLCStatus] = 'P' AND PRSDS.[IsActive] = 1 
END