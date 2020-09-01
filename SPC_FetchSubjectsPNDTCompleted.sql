USE [Eduquaydb]
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
(
	@UserInput  VARCHAR(MAX)
)
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
		,(SELECT Top 1 [CBCResult] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) AS SpouseCBCResult
		, CASE WHEN (SELECT TOP 1 [SSTStatus] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,(SELECT TOP 1 [HPLCTestResult] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) AS SpouseHPLCResult
		,PT.[ObstetricianId]	
		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS ObsetricianName
		,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] 
		,'The couple has agreed for Pre-natal Diagnosis' AS CounsellingStatus
		,PT.[ID] AS PNDTTestID
		,PT.[ClinicalHistory]
		,PT.[Examination]
		, CASE WHEN POT.[ProcedureName] = 'Others' THEN POT.[ProcedureName] + '(' + PT.[OthersProcedureofTesting] + ')'
			ELSE POT.[ProcedureName] END AS ProcedureOfTesting
		,(SELECT [dbo].[FN_GetPNDTSubjectComplications](PT.[ID])) AS Complications
		,PT.[PNDTDiagnosisId] 
		,PDM.[DiagnosisName]  AS PNDTDiagnosis
		,PT.[PNDTResultId] 
		,PRM.[ResultName] AS PNDTResults
		,CASE WHEN PT.[MotherVoided] = 0 THEN 'NO' ELSE 'YES' END AS  MotherVoided
		,CASE WHEN PT.[MotherVitalStable]  = 0 THEN 'NO' ELSE 'YES' END AS MotherVitalStable
		,CASE WHEN PT.[FoetalHeartRateDocumentScan]= 0 THEN 'NO' ELSE 'YES' END AS  FoetalHeartRatedocumentedinScan
		,CASE WHEN PT.[PlanForPregnencyContinue] = 0  THEN 'Plan for MTP' ELSE 'OG Follow up' END AS PlanforPregnancy
	FROM Tbl_PNDTest PT 
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH (NOLOCK) ON  PT.[ANWSubjectId] = PPC.[ANWSubjectId]
	LEFT JOIN Tbl_PrePNDTScheduling PPS WITH (NOLOCK) ON PT.[ANWSubjectId] = PPS.[ANWSubjectId]
	LEFT JOIN Tbl_PNDTDiagnosisMaster PDM WITH (NOLOCK) ON PDM.[ID] = PT.[PNDTDiagnosisId]
	LEFT JOIN Tbl_PNDTResultMaster  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN Tbl_PNDTProcedureOfTestingMaster POT  WITH (NOLOCK) ON POT.[ID] = PT.[ProcedureofTestingId] 
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSD WITH (NOLOCK) ON PT.[ANWSubjectId] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID] 
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PT.[CounsellorId] = UM.[ID]
	LEFT JOIN Tbl_UserMaster UM1 WITH(NOLOCK) ON PT.[ObstetricianId] = UM1.[ID] 
	WHERE SPD.[UniqueSubjectID] IN (SELECT UniqueSubjectID FROM Tbl_PositiveResultSubjectsDetail WHERE HPLCStatus ='P' AND IsActive = 1) 
	AND SPD.[SpouseSubjectID] IN (SELECT UniqueSubjectID FROM Tbl_PositiveResultSubjectsDetail WHERE HPLCStatus ='P' AND IsActive = 1)
	AND PRSD.[IsActive]  = 1
	AND  (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPC.[IsPNDTAgreeYes] = 1 AND PPC.[IsActive] = 0
	AND PT.IsCompletePNDT = 1
	AND (@UserInput = '' OR SPD.[FirstName] LIKE '%'+@UserInput+'%' OR SPD.[LastName] LIKE '%'+@UserInput+'%'  
	OR PT.[ANWSubjectId] LIKE '%'+@UserInput+'%' OR SPR.[RCHID] LIKE '%'+@UserInput+'%'  OR SPD.[MobileNo] LIKE '%'+@UserInput+'%' )
	ORDER BY PT.[UpdatedOn] DESC
END

