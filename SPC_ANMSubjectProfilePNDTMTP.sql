USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Profile PNDT and MTP Details For ANM

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_ANMSubjectProfilePNDTMTP' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_ANMSubjectProfilePNDTMTP 
END
GO
CREATE PROCEDURE [dbo].[SPC_ANMSubjectProfilePNDTMTP] 
(
	@UserId INT
)
AS
BEGIN
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) AS PrePNDTCounsellingDate
		,CONVERT(VARCHAR(5),PPS.[CounsellingDateTime],108) AS PrePNDTCounsellingTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS PrePNDTCounsellorName
		,PPC.[CounsellingRemarks]  AS PrePNDTCounsellingNotes
		,CASE WHEN PPC.[IsPNDTAgreeYes] = 1 THEN  'The couple has agreed for Pre-natal Diagnosis Test' 
		 WHEN PPC.[IsPNDTAgreeNo] = 1 THEN 'The couple hasn''t agreed for Pre-natal Diagnosis Test' 
		 WHEN  PPC.[IsPNDTAgreePending]  = 1 THEN 'The couple has been taken decision pending for Pre-natal Diagnosis Test' 
		 END AS PrePNDTCounsellingStatus
		,CASE WHEN PPC.[IsPNDTAgreeYes] = 1 THEN 'YES'
			  WHEN PPC.[IsPNDTAgreeYes] = 0 THEN 'No' 
			  ELSE NULL END  AS AgreeForPNDT
		
		,CONVERT(VARCHAR,PT.[PNDTDateTime],103) AS PNDTDate
		,CONVERT(VARCHAR(5),PT.[PNDTDateTime],108) AS PNDTTime
		,(UMP.[FirstName] + ' ' + UMP.[LastName]) AS PNDTCounsellorName
		,(UM1.[FirstName] + ' ' + UM1.[LastName]) AS PNDTObstetricianName
		,PT.[ClinicalHistory] AS PNDTClinicalHistory
		,PT.[Examination] AS PNDTExamination
		,CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS PNDTProcedureOfTesting
		,PD.[DiagnosisName] AS PNDTDiagnosisName 
		,PRM.[ResultName] AS PNDTResults
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS PNDTSideEffects
		
		,CONVERT(VARCHAR,POPS.[CounsellingDateTime],103) AS PostPNDTCounsellingDate
		,CONVERT(VARCHAR(5),POPS.[CounsellingDateTime],108) AS PostPNDTCounsellingTime
		,(UMPO.[FirstName] + ' ' + UMPO.[LastName]) AS PostPNDTCounsellorName
		,POPC.[CounsellingRemarks]  AS PostPNDTCounsellingNotes
		,CASE WHEN POPC.[IsMTPTestdAgreedYes] = 1 THEN  'The couple has agreed for MTP service' 
		 WHEN POPC.[IsMTPTestdAgreedNo] = 1 THEN 'The couple hasn''t agreed for MTP service' 
		 WHEN  POPC.[IsMTPTestdAgreedPending]  = 1 THEN 'The couple has been taken decision pending for MTP service' 
		 END AS PostPNDTCounsellingStatus
		,CASE WHEN POPC.[IsMTPTestdAgreedYes] = 1 THEN 'YES'
			  WHEN POPC.[IsMTPTestdAgreedYes] = 0 THEN 'No' 
			  ELSE NULL END  AS AgreeForMTP
			  
		,CONVERT(VARCHAR,MT.[MTPDateTime],103) AS MTPDate
		,CONVERT(VARCHAR(5),MT.[MTPDateTime],108) AS MTPTime
		,(UMMC.[FirstName] + ' ' + UMMC.[LastName]) AS MTPCounsellorName
		,(UMMO.[FirstName] + ' ' + UMMO.[LastName]) AS MTPObstetricianName
		,MT.[ClinicalHistory] AS MTPClinicalHistory 
		,MT.[Examination] AS MTPExamination
		,MT.[ProcedureofTesting] AS MTPProcedureOfTesting
		,DCM.[DischargeConditionName] AS MTPDischargeCondition
		,(SELECT [dbo].[FN_GetMTPSubjectComplications](MT.[ID])) AS MTPComplications
	FROM  Tbl_PrePNDTCounselling PPC
	LEFT JOIN [dbo].[Tbl_PrePNDTScheduling]  PPS WITH (NOLOCK) ON PPS.[ANWSubjectId] = PPC.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPC.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = PPC.[CounsellorId] 
	
	LEFT JOIN [dbo].[Tbl_PNDTest] PT WITH (NOLOCK) ON PT.[ANWSubjectId] = SP.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UMP WITH (NOLOCK) ON UMP.[ID] = PT.[CounsellorId] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM1 WITH (NOLOCK) ON UM1.[ID] = PT.[ObstetricianId]  
	LEFT JOIN [dbo].[Tbl_PNDTProcedureOfTestingMaster] POT WITH (NOLOCK) ON PT.[ProcedureofTestingId] = POT.[ID] 
	LEFT JOIN [dbo].[Tbl_PNDTResultMaster]  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN [dbo].[Tbl_PNDTDiagnosisMaster] PD WITH (NOLOCK) ON PD.[ID] = PT.[PNDTDiagnosisId]  
	
	LEFT JOIN [dbo].[Tbl_PostPNDTCounselling]  POPC WITH (NOLOCK) ON POPC.[ANWSubjectId] = SP.[UniqueSubjectID]  
	LEFT JOIN [dbo].[Tbl_PostPNDTScheduling]  POPS WITH (NOLOCK) ON POPS.[ANWSubjectId] = POPC.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UMPO WITH (NOLOCK) ON UMPO.[ID] = POPC.[CounsellorId] 
	
	LEFT JOIN [dbo].[Tbl_MTPTest] MT WITH (NOLOCK) ON MT.[ANWSubjectId] = SP.[UniqueSubjectID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UMMC WITH (NOLOCK) ON UMMC.[ID] = MT.[CounsellorId] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UMMO WITH (NOLOCK) ON UMMO.[ID] = MT.[ObstetricianId]  
	LEFT JOIN Tbl_DischargeConditionMaster DCM WITH (NOLOCK) ON DCM.[ID] = MT.[DischargeConditionId]
	
	WHERE SP.[AssignANM_ID]  = @UserId    
	ORDER BY SP.[UniqueSubjectID] 
END