--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPostPNDTCounselling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPostPNDTCounselling
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPostPNDTCounselling] 
(
	 @UserId INT
	 ,@DistrictId INT
	 ,@CHCId INT
	 ,@PHCId INT
	 ,@ANMId INT 
)
AS
BEGIN
	SELECT PT.[ANWSubjectId]
		,SPD.[SpouseSubjectID]
		,(SPD.[FirstName] + ' ' + SPD.[LastName] )AS SubjectName
		,SPR.[RCHID]
		,(SPD.[Spouse_FirstName] + ' '+ SPD.[Spouse_LastName] ) AS SpouseName
		,SPD.[MobileNo] AS ContactNo
		,('G'+CONVERT(VARCHAR,SPR.[G])+'-P'+CONVERT(VARCHAR,SPR.[P])+'-L'+CONVERT(VARCHAR,SPR.[L])+'-A'+
			CONVERT(VARCHAR,SPR.[A])) AS ObstetricScore
		,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[ID]))) AS [GestationalAge]
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

		,SCTR.[MCV] AS Spouse_MCV
		,SCTR.[RDW] AS Spouse_RDW
		,SCTR.[RBC] AS Spouse_RBC

		,SHTR.[HbF] AS Spouse_HbF
		,SHTR.[HbS] AS Spouse_HbS
		,SHTR.[HbD] AS Spouse_HbD
		,SHTR.[HbA0] AS Spouse_HbA0
		,SHTR.[HbA2] AS Spouse_HbA2

		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS PrePNDTCounsellorName
		,(CONVERT(VARCHAR,PPSS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PPSS.[CounsellingDateTime],103))) AS PrePNDTCounsellingDateTime
		,'The couple has agreed for Pre-natal Diagnosis' AS PreNDTCounsellingStatus
		,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] AS PrePNDTCounsellingRemarks
		
		--,PT.[PNDTResultId] 
		--,PRM.[ResultName] AS PNDTResults
		--,CASE WHEN PRM.[IsPositive] = 1 THEN  1 ELSE 0 END AS FoetalDisease 
		,PT.[ObstetricianId] 
		,(UM2.[FirstName] +' '+UM2.[LastName] ) AS PNDTestObstetrician
		,(CONVERT(VARCHAR,PT.[PNDTDateTime],103) + ' ' +CONVERT(VARCHAR(5),CONVERT(TIME(2),PT.[PNDTDateTime],103))) AS PNDDateTime
		--,PD.[DiagnosisName] AS PNDTDiagnosisName

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
		,UM3.[FirstName] AS MolucularResultUpdatedBy
		,CONVERT(VARCHAR,PF.[ResultUpdatedOn],103) AS MolecularResultUpdatedOn
		,CASE WHEN PF.[PlanForPregnencyContinue] = 0  THEN 'Plan for MTP' ELSE 'OG Follow up' END AS PlanforPregnancy
		,PF.[PlanForPregnencyContinue]
		,UM4.[FirstName] AS ResultReviewedBy
		,CONVERT(VARCHAR,PF.[ReviewedOn],103) AS ResultReviewedOn

		,PPS.[ID] AS PostPNDTSchedulingId
		,PPS.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS PostPNDTCounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PPS.[CounsellingDateTime],103))) AS CounsellingDateTime


	FROM Tbl_PostPNDTScheduling PPS
	LEFT JOIN Tbl_PNDTestNew PT WITH (NOLOCK) ON PPS.[ANWSubjectId] = PT.[ANWSubjectId]
	LEFT JOIN Tbl_PNDTFoetusDetail PF WITH (NOLOCK) ON PT.[ID] = PF.[PNDTestId]
	LEFT JOIN Tbl_PNDTProcedureOfTestingMaster POT  WITH (NOLOCK) ON POT.[ID] = PT.[ProcedureofTestingId] 
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH(NOLOCK) ON PPC.[ID] = PT.[PrePNDTCounsellingId]
	LEFT JOIN Tbl_PrePNDTScheduling  PPSS WITH(NOLOCK) ON PPSS.[ID] = PPC.[PrePNDTSchedulingId]  
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_SubjectPrimaryDetail SPDS WITH (NOLOCK) ON SPDS.[UniqueSubjectID] = SPD.[SpouseSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSDS WITH (NOLOCK) ON PRSDS.[UniqueSubjectID] = SPDS.[UniqueSubjectID]

	LEFT JOIN Tbl_CBCTestResult CTR WITH (NOLOCK) ON CTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_CBCTestResult SCTR WITH (NOLOCK) ON SCTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult HTR WITH (NOLOCK) ON HTR.[BarcodeNo] = PRSD.[BarcodeNo]
	LEFT JOIN Tbl_HPLCTestResult SHTR WITH (NOLOCK) ON SHTR.[BarcodeNo] = PRSDS.[BarcodeNo]
	 
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPS.[CounsellorId] = UM.[ID] 
	LEFT JOIN Tbl_UserMaster UM1 WITH (NOLOCK) ON UM1.[ID] = PPC.[CounsellorId] 
	LEFT JOIN Tbl_UserMaster UM2 WITH (NOLOCK) ON UM2.[ID] = PT.[ObstetricianId]
	LEFT JOIN Tbl_UserMaster UM3 WITH(NOLOCK) ON PF.[ResultUpdatedBy] = UM2.[ID] 
	LEFT JOIN Tbl_UserMaster UM4 WITH(NOLOCK) ON PF.[ReviewedBy] = UM2.[ID] 
	WHERE PRSD.[HPLCStatus] = 'P' AND PRSD.[IsActive] = 1 AND PRSDS.[HPLCStatus] = 'P' AND PRSDS.[IsActive] = 1
	AND (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPS.[IsCounselled] = 0 
	AND SPD.[UniqueSubjectID] NOT IN (SELECT ANWSubjectId FROM Tbl_PostPNDTCounselling)
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId) 
	ORDER BY [GestationalAge] DESC 
END

