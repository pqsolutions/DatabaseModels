USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are MTP Referal for  DC in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDCNotificationMTPReferal' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDCNotificationMTPReferal 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDCNotificationMTPReferal] 
(
	@DistrictId INT
)
AS
BEGIN
	
	SELECT SP.[UniqueSubjectID] AS ANWSubjectId 
		,SP1.[UniqueSubjectID] AS SpouseSubjectId
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS ANWSubjectName
		,(SP1.[FirstName] + ' ' + SP1.[MiddleName] + ' ' + SP1.[LastName]) AS SpouseSubjectName
		,SPR.[RCHID] 
		,(SELECT [dbo].[FN_FindBarcodesByUser](SP.[ID])) AS ANWBarcodeNo
		,(SELECT [dbo].[FN_FindBarcodesByUser](SP1.[ID])) AS SpouseBarcodeNo
		,SP.[MobileNo] AS ANWContactNo
		,SP1.[MobileNo] AS SpouseContactNo
		,SP.[Age] AS ANWAge
		,SP1.[Age] AS SpouseAge
		,SPR.[ECNumber]
		,SP.[Gender] AS ANWGender
		,SP1.[Gender] AS SpouseGender
		,(SAD.[Address1] + ' ' + SAD.[Address2] + ' ' + SAD.[Address3]) AS SubjectAddress
		,('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
		CONVERT(VARCHAR,SPR.[A])) AS GPLA
		,CONVERT(VARCHAR,SPR.[LMP_Date],103) AS LMPDate
		,CONVERT(VARCHAR,SP.[DOB] ,103) AS ANWDateOFBirth
		,CONVERT(VARCHAR,SP1.[DOB] ,103) AS SpouseDateOFBirth
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		,SP.[AssignANM_ID] 
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS ANMName
		,UM.[ContactNo1] AS ANMContactNo
		
		,DM.[Districtname] AS ANWDistrict
		,CM.[CHCname] AS ANWCHCName
		,PM.[PHCname] AS ANWPHCName
		,S.[SCname] AS ANWSCName
		,RI.[RIsite] AS ANWRIPoint 
		,RM.[Religionname] AS ANWReligion
		,CA.[Castename] AS ANWCaste
		,CO.[Communityname] AS ANWCommunity
		
		,DM1.[Districtname] AS SpouseDistrict
		,CM1.[CHCname] AS SpouseCHCName
		,PM1.[PHCname] AS SpousePHCName
		,S1.[SCname] AS SpouseSCName
		,RI1.[RIsite] AS SpouseRIPoint 
		,RM1.[Religionname] AS SpouseReligion
		,CA1.[Castename] AS SpouseCaste
		,CO1.[Communityname] AS SpouseCommunity
		
		,PRSD.[CBCResult] AS ANWCBCResult
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS ANWSSTResult
		,PRSD.[HPLCTestResult] AS ANWHPLCResult
		
		,PRSDS.[CBCResult] AS SpouseCBCResult
		,CASE WHEN PRSDS.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,PRSDS.[HPLCTestResult] AS SpouseHPLCResult
		
		,(PCUM.[FirstName] + ' ' + PCUM.[LastName]) AS PNDTCounsellorName
		,PPC.[CounsellingRemarks] PNDTCounsellingRemarks
		,'The couple has agreed for Pre-natal Diagnosis Test' AS PNDTCounsellingStatus
		,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		
		,(CONVERT(VARCHAR,PT.[UpdatedOn],103) + ' ' + CONVERT(VARCHAR(5),PT.[UpdatedOn],108)) AS PNDTDateTime
		,(PTOUM.[FirstName] + ' ' + PTOUM.[LastName]) AS PNDTObstetricianName
		,PT.[ClinicalHistory] 
		,PT.[Examination]
		,PD.[DiagnosisName] AS PNDTDiagnosisName 
		,PRM.[ResultName] AS PNDTResults
		,CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS PNDTProcedureOfTesting
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS PNDTSideEffects
		
		,(CONVERT(VARCHAR,MTPR.[PostPNDTCounsellingDate],103) + ' ' + CONVERT(VARCHAR(5),MTPR.[PostPNDTCounsellingDate],108)) AS PostPNDTCounsellingDate
		,CASE WHEN ISNULL(MTPR.[MTPScheduleDateTime],'') = '' THEN
		'' ELSE (CONVERT(VARCHAR,MTPR.[MTPScheduleDateTime],103) + ' ' + CONVERT(VARCHAR(5),MTPR.[MTPScheduleDateTime],108)) END AS MTPDate
		,MTPR.[ID] AS MTPReferalId
		,ISNULL(MTPR.[FollowUpStatus],0) AS FollowUpStatus
		
		
	FROM  Tbl_MTPReferal MTPR
	LEFT JOIN Tbl_PrePNDTCounselling PPC  WITH (NOLOCK) ON PPC.[ANWSubjectId] = MTPR.[ANWSubjectId]
	LEFT JOIN Tbl_PNDTest PT  WITH (NOLOCK) ON PT.[ANWSubjectId] = MTPR.[ANWSubjectId]
	LEFT JOIN Tbl_UserMaster PCUM  WITH (NOLOCK) ON PPC.[CounsellorId] = PCUM.[ID]
	LEFT JOIN Tbl_UserMaster PTOUM  WITH (NOLOCK) ON PT.[ObstetricianId] = PTOUM.[ID]
	LEFT JOIN Tbl_PNDTResultMaster  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN Tbl_PNDTDiagnosisMaster PD WITH (NOLOCK) ON PD.[ID] = PT.[PNDTDiagnosisId] 
	LEFT JOIN Tbl_PNDTProcedureOfTestingMaster POT  WITH (NOLOCK) ON POT.[ID] = PT.[ProcedureofTestingId] 
	 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MTPR.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP1 WITH (NOLOCK) ON SP1.[UniqueSubjectID] = SP.[SpouseSubjectID] AND SP1.[UniqueSubjectID] = MTPR.[SpouseSubjectId] 
	LEFT JOIN  [dbo].[Tbl_SubjectAddressDetail]   SAD WITH (NOLOCK) ON SAD.[SubjectID] = SP.[ID]
	LEFT JOIN  [dbo].[Tbl_SubjectAddressDetail]   SAD1 WITH (NOLOCK) ON SAD1.[SubjectID] = SP1.[ID]  
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = SP.[AssignANM_ID] 
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM WITH (NOLOCK) ON DM.[ID] = SP.[DistrictID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID] 
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM WITH (NOLOCK) ON PM.[ID] = SP.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] S WITH (NOLOCK) ON S.[ID] = SP.[SCID]   
	LEFT JOIN [dbo].[Tbl_RIMaster] RI WITH (NOLOCK) ON RI.[ID] = SP.[RIID]
	LEFT JOIN [dbo].[Tbl_ReligionMaster] RM WITH (NOLOCK) ON RM.[ID] = SAD.[Religion_Id] 
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA WITH (NOLOCK) ON CA.[ID]  = SAD.[Caste_Id]  
	LEFT JOIN [dbo].[Tbl_CommunityMaster] CO WITH (NOLOCK) ON CO.[ID]  = SAD.[Community_Id]
	
	LEFT JOIN [dbo].[Tbl_DistrictMaster] DM1 WITH (NOLOCK) ON DM1.[ID] = SP1.[DistrictID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM1 WITH (NOLOCK) ON CM1.[ID] = SP1.[CHCID] 
	LEFT JOIN [dbo].[Tbl_PHCMaster] PM1 WITH (NOLOCK) ON PM1.[ID] = SP1.[PHCID]
	LEFT JOIN [dbo].[Tbl_SCMaster] S1 WITH (NOLOCK) ON S1.[ID] = SP1.[SCID]   
	LEFT JOIN [dbo].[Tbl_RIMaster] RI1 WITH (NOLOCK) ON RI1.[ID] = SP1.[RIID]
	LEFT JOIN [dbo].[Tbl_ReligionMaster] RM1 WITH (NOLOCK) ON RM1.[ID] = SAD1.[Religion_Id] 
	LEFT JOIN [dbo].[Tbl_CasteMaster] CA1 WITH (NOLOCK) ON CA1.[ID]  = SAD1.[Caste_Id]  
	LEFT JOIN [dbo].[Tbl_CommunityMaster] CO1 WITH (NOLOCK) ON CO1.[ID]  = SAD1.[Community_Id]
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSD WITH (NOLOCK) ON PRSD.[UniqueSubjectID]  = MTPR.[ANWSubjectId]    
	LEFT JOIN [dbo].[Tbl_PositiveResultSubjectsDetail] PRSDS WITH (NOLOCK) ON PRSDS.[UniqueSubjectID]  = SP.[SpouseSubjectID] AND SP.[SpouseSubjectID] = MTPR.[SpouseSubjectId] 
	WHERE SP.[DistrictID]  = @DistrictId  AND MTPR.[IsNotified] = 0 AND MTPR.[IsMTPCompleted] = 0 
	ORDER BY GestationalAge DESC	 		
	
END