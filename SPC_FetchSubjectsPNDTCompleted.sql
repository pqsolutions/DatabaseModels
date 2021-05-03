--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPNDTCompleted' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPNDTCompleted
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPNDTCompleted] 
--(
--	@MolecularLabId  INT
--)
AS
BEGIN
	SELECT SPD.[UniqueSubjectID] AS ANWSubjectId
		,SPD.[SpouseSubjectID]
		,(SPD.[FirstName] + ' ' + SPD.[LastName] )AS SubjectName
		,SPR.[RCHID]
		,(SPD.[Spouse_FirstName] + ' '+ SPD.[Spouse_LastName] ) AS SpouseName
		,SPD.[MobileNo] AS ContactNo
		,('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			CONVERT(VARCHAR,SPR.[A])) AS ObstetricScore
		,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[ID])) AS [GestationalAge]
		,SPD.[AssignANM_ID] 
		,SPD.[Age]
		,SPDS.[Age] AS SpouseAge
		,SPR.[ECNumber] 
		,(CONVERT(VARCHAR,SPR.[LMP_Date],103))AS LMPDate
		,PT.[PrePNDTCounsellingId]   AS CounsellingId
		,PPC.[PrePNDTSchedulingId] AS SchedulingId
		,PT.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS CounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),CounsellingDateTime,103))) AS CounsellingDateTime
		,PRSD.[CBCResult] AS ANWCBCResult
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS ANWSSTResult
		,PRSD.[HPLCTestResult] AS ANWHPLCResult

		,PRSDS.[CBCResult] AS SpouseCBCResult
		,CASE WHEN PRSDS.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,PRSDS.[HPLCTestResult] AS SpouseHPLCResult

		,CTR.[MCV] AS ANW_MCV
		,CTR.[RDW] AS ANW_RDW
		,CTR.[RBC] AS ANW_RBC

		,HTR.[HbA0] AS ANW_HbA0
		,HTR.[HbA2] AS ANW_HbA2
		,HTR.[HbF] AS ANW_HbF
		,HTR.[HbS] AS ANW_HbS
		,HTR.[HbD] AS ANW_HbD
		,HTR.[LabDiagnosis] AS ANWHPLCDiagnosis
		
		,SCTR.[MCV] AS Spouse_MCV
		,SCTR.[RDW] AS Spouse_RDW
		,SCTR.[RBC] AS Spouse_RBC

		,SHTR.[HbF] AS Spouse_HbF
		,SHTR.[HbS] AS Spouse_HbS
		,SHTR.[HbD] AS Spouse_HbD
		,SHTR.[HbA0] AS Spouse_HbA0
		,SHTR.[HbA2] AS Spouse_HbA2
		,SHTR.[LabDiagnosis] AS SPouseHPLCDiagnosis

		,HDRA.[SeniorPathologistRemarks] AS ANWPathoRemarks
		,SHDRA.[SeniorPathologistRemarks] AS SpousePathoRemarks

		,PT.[ObstetricianId]	
		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS ObsetricianName
		,CONVERT(VARCHAR,PT.[PNDTDateTime],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PT.[PNDTDateTime],108) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] 
		,'The couple has agreed for Pre-natal Diagnosis' AS CounsellingStatus
		,PT.[ID] AS PNDTTestID
		,PT.[ClinicalHistory]
		,PT.[Examination]
		, CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS ProcedureOfTesting
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS Complications
		
		,CASE WHEN PT.[MotherVoided] = 0 THEN 'Mother voided - NO' ELSE 'Mother voided - YES' END AS  MotherVoided
		,CASE WHEN PT.[MotherVitalStable]  = 0 THEN 'Mother vitals (pulse & Bp) stable - NO' ELSE 'Mother vitals (pulse & Bp) stable - YES' END AS MotherVitalStable
		,CASE WHEN PT.[FoetalHeartRateDocumentScan]= 0 THEN 'Foetal heart rate document in scan - NO' ELSE 'Foetal heart rate document in scan - YES' END AS  FoetalHeartRatedocumentedinScan
		,PF.[PregnancyType]
		,PF.[ID] AS PNDFoetusId
		,PF.[MolResult]
		,PF.[FoetusName]
		,PF.[SampleRefId]
		,PF.[CVSSampleRefId]
		,UM2.[FirstName] AS MolucularResultUpdatedBy
		,CONVERT(VARCHAR,PF.[ResultUpdatedOn],103) AS MolecularResultUpdatedOn
		,CASE WHEN PF.[PlanForPregnencyContinue] IS NULL  THEN ''  WHEN PF.[PlanForPregnencyContinue] = 0  THEN 'Plan for MTP' ELSE 'OG Follow up' END AS PlanforPregnancy
		,UM3.[FirstName] AS ResultReviewedBy
		,CONVERT(VARCHAR,PF.[ReviewedOn],103) AS ResultReviewedOn
		,PT.IsCompletePNDT
	FROM Tbl_PNDTestNew PT 
	LEFT JOIN Tbl_PNDTFoetusDetail PF WITH (NOLOCK) ON PT.[ID] = PF.[PNDTestId]
	LEFT JOIN Tbl_MolecularSpecimenTestResult MSTR WITH (NOLOCK) ON  MSTR.[PNDTFoetusId] = PF.[ID]
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH (NOLOCK) ON  PT.[ANWSubjectId] = PPC.[ANWSubjectId]
	LEFT JOIN Tbl_PrePNDTScheduling PPS WITH (NOLOCK) ON PT.[ANWSubjectId] = PPS.[ANWSubjectId]
	LEFT JOIN Tbl_PNDTProcedureOfTestingMaster POT  WITH (NOLOCK) ON POT.[ID] = PT.[ProcedureofTestingId] 
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSD WITH (NOLOCK) ON PT.[ANWSubjectId] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSDS WITH (NOLOCK) ON PRSDS.[UniqueSubjectID] = PT.[SpouseSubjectId]
	LEFT JOIN Tbl_HPLCDiagnosisResult HDRA WITH (NOLOCK) ON PRSD.[BarcodeNo] = HDRA.[BarcodeNo]
	LEFT JOIN Tbl_HPLCDiagnosisResult SHDRA WITH (NOLOCK) ON PRSDS.[BarcodeNo] = SHDRA.[BarcodeNo]
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PT.[ANWSubjectId] 
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID]
	LEFT JOIN Tbl_SubjectPrimaryDetail SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = PT.[SpouseSubjectId]
	LEFT JOIN Tbl_CBCTestResult CTR WITH (NOLOCK) ON CTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_CBCTestResult SCTR WITH (NOLOCK) ON SCTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult HTR WITH (NOLOCK) ON HTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult SHTR WITH (NOLOCK) ON SHTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PT.[CounsellorId] = UM.[ID]
	LEFT JOIN Tbl_UserMaster UM1 WITH(NOLOCK) ON PT.[ObstetricianId] = UM1.[ID]
	LEFT JOIN Tbl_UserMaster UM2 WITH(NOLOCK) ON PF.[ResultUpdatedBy] = UM2.[ID] 
	LEFT JOIN Tbl_UserMaster UM3 WITH(NOLOCK) ON PF.[ReviewedBy] = UM3.[ID] 
	WHERE PRSD.[HPLCStatus] = 'P' AND PRSD.[IsActive] = 1 AND PRSDS.[HPLCStatus] = 'P' AND PRSDS.[IsActive] = 1
	AND (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPC.[IsPNDTAgreeYes] = 1 AND PPC.[IsActive] = 0
	--AND PT.IsCompletePNDT = 1 ANd PT.IsMolTestCompleted = 1 --AND (MSTR.[MolecularLabId] = @MolecularLabId OR @MolecularLabId = 0)
	ORDER BY PT.[PNDTDateTime]  DESC
END

