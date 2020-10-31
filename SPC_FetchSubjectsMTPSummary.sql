USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsMTPSummary' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsMTPSummary
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsMTPSummary] 
AS
BEGIN
	SELECT MTP.[ANWSubjectId]
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


		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS PrePNDTCounsellorName
		,(CONVERT(VARCHAR,PPSS.[CounsellingDateTime],103) + ' ' + CONVERT(VARCHAR(5),PPSS.[CounsellingDateTime],108)) AS PrePNDTCounsellingDateTime
		  ,'The couple has agreed for Pre-natal Diagnosis' AS PrePNDTCounsellingStatus
		  	,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] AS PrePNDTCounsellingRemarks
		, CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS PNDTProcedureOfTesting
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS PNDTComplications
		,PT.[PNDTResultId] 
		,PRM.[ResultName] AS PNDTResults
		,CASE WHEN PRM.[IsPositive] = 1 THEN  1 ELSE 0 END AS FoetalDisease 
		,PT.[ObstetricianId] 
		,(UM2.[FirstName] +' '+UM2.[LastName] ) AS PNDTestObstetrician
		,(CONVERT(VARCHAR,PT.[PNDTDateTime],103) + ' ' + CONVERT(VARCHAR(5),PT.[PNDTDateTime],108)) AS PNDDateTime
		  ,PT.[ClinicalHistory]  AS PNDTClinicalHistory
		  ,PT.[Examination] AS PNDTExamination
		  ,PD.[DiagnosisName] AS PNDTDiagnosisName
		,PPS.[ID] AS PostPNDTSchedulingId
		,PPS.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS PostPNDTCounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' + CONVERT(VARCHAR(5),PPS.[CounsellingDateTime],108)) AS PostPNDTCounsellingDateTime
		,PPCC.[ID]  AS PostPNDTCounsellingId
		,PPCC.[AssignedObstetricianId]	
		,(UM3.[FirstName] +' '+UM3.[LastName] ) AS PostPNDTObsetricianName
		,CONVERT(VARCHAR,MTP.[MTPDateTime],103) AS ScheduleMTPDate
		,CONVERT(VARCHAR(5),MTP.[MTPDateTime],108) AS ScheduleMTPTime
		,PPCC.[CounsellingRemarks] AS PostPNDTCounsellingRemarks
		,'The couple has agreed for MTP Service' AS PostPNDTCounsellingStatus 
		,MTP.[ID] AS MTPID
		,MTP.[ObstetricianId] AS MTPObstetricianId
		,MTP.[CounsellorId] AS MTPCounsellorId
		,(UMM.[FirstName] +' '+UMM.[LastName] ) AS MTPCounsellorName
		,(UMMM.[FirstName] +' '+UMMM.[LastName] ) AS MTPObstetricianName
		,MTP.[ClinicalHistory] AS MTPClinicalHistory
		,MTP.[Examination] AS MTPExamination
		,MTP.[ProcedureofTesting] AS MTPProcedureOfTesting
		,MTP.[DischargeConditionId]
		,DCM.[DischargeConditionName]
		,MTP.[MTPComplecationsId] 
		,(SELECT [dbo].[FN_GetMTPSubjectComplications](MTP.[ID])) AS MTPComplications
	FROM Tbl_MTPTest  MTP
	LEFT JOIN  Tbl_PostPNDTCounselling  PPCC WITH (NOLOCK) ON PPCC.[ID] = MTP.[PostPNDTCounsellingId] 
	LEFT JOIN Tbl_PostPNDTScheduling PPS WITH (NOLOCK) ON PPS.[ANWSubjectId] = PPCC.[ANWSubjectId] 
	LEFT JOIN Tbl_PNDTest PT WITH (NOLOCK) ON PPS.[ANWSubjectId] = PT.[ANWSubjectId] 
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH(NOLOCK) ON PPC.[ID] = PT.[PrePNDTCounsellingId]
	LEFT JOIN Tbl_PrePNDTScheduling  PPSS WITH(NOLOCK) ON PPSS.[ID] = PPC.[PrePNDTSchedulingId]  
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = MTP.[ANWSubjectId]
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSD WITH (NOLOCK) ON MTP.[ANWSubjectId] = PRSD.[UniqueSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSDS WITH (NOLOCK) ON PRSDS.[UniqueSubjectID] = MTP.[SpouseSubjectId]
	LEFT JOIN Tbl_SubjectPrimaryDetail SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = PRSDS.[UniqueSubjectID]

	LEFT JOIN Tbl_CBCTestResult CTR WITH (NOLOCK) ON CTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_CBCTestResult SCTR WITH (NOLOCK) ON SCTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult HTR WITH (NOLOCK) ON HTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult SHTR WITH (NOLOCK) ON SHTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_PNDTResultMaster  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN Tbl_PNDTProcedureOfTestingMaster POT  WITH (NOLOCK) ON POT.[ID] = PT.[ProcedureofTestingId] 
	LEFT JOIN Tbl_PNDTDiagnosisMaster PD WITH (NOLOCK) ON PD.[ID] = PT.[PNDTDiagnosisId] 
	LEFT JOIN Tbl_DischargeConditionMaster DCM WITH (NOLOCK) ON DCM.[ID] = MTP.[DischargeConditionId] 
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPS.[CounsellorId] = UM.[ID] 
	LEFT JOIN Tbl_UserMaster UM1 WITH (NOLOCK) ON UM1.[ID] = PPC.[CounsellorId] 
	LEFT JOIN Tbl_UserMaster UM2 WITH (NOLOCK) ON UM2.[ID] = PT.[ObstetricianId]
	LEFT JOIN Tbl_UserMaster UM3 WITH (NOLOCK) ON UM3.[ID] = PPCC.[AssignedObstetricianId]
	LEFT JOIN Tbl_UserMaster UMM WITH (NOLOCK) ON UMM.[ID] = MTP.[CounsellorId]
	LEFT JOIN Tbl_UserMaster UMMM WITH (NOLOCK) ON UMMM.[ID] = MTP.[ObstetricianId]  
	WHERE (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPS.[IsCounselled] = 1 
	AND PPCC.[IsMTPTestdAgreedYes] = 1 AND PPCC.[IsActive] = 0 
	AND PRSD.[HPLCStatus] = 'P' AND PRSDS.[HPLCStatus] = 'P' 
	ORDER BY MTP.[UpdatedOn] DESC
END