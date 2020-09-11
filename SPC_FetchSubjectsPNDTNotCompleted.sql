USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPNDTNotCompleted' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPNDTNotCompleted
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPNDTNotCompleted] 
(
	 @DistrictId INT
	 ,@CHCId INT
	 ,@PHCId INT
	 ,@ANMId INT  
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
		,CONVERT(DECIMAL(10,1),(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[ID]))) AS [GestationalAge]
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
		, (SELECT DiagnosisName FROM Tbl_ClinicalDiagnosisMaster WHERE ID =(SELECT TOP 1 ClinicalDiagnosisId FROM Tbl_HPLCDiagnosisResult
			WHERE UniqueSubjectID = SPD.[UniqueSubjectID])) AS ANWHPLCDiagnosis
		,(SELECT DiagnosisName FROM Tbl_ClinicalDiagnosisMaster WHERE ID =(SELECT TOP 1 ClinicalDiagnosisId FROM Tbl_HPLCDiagnosisResult
			WHERE UniqueSubjectID = SPD.[SpouseSubjectID])) AS SPouseHPLCDiagnosis
		,PT.[ObstetricianId]	AS AssignedObstetricianId
		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS ObsetricianName
		,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] 
		,'The couple has agreed for Pre-natal Diagnosis' AS CounsellingStatus
		,PT.[ID] AS PNDTTestID
		,PT.[ClinicalHistory]
		,PT.[Examination]
		,PT.[ProcedureofTestingId] 
		,PT.[OthersProcedureofTesting]
		,PT.[PNDTComplecationsId] 
		,PT.[OthersComplecations]
		,PT.[PNDTDiagnosisId] 
		,PT.[PNDTResultId] 
		,PT.[MotherVoided] 
		,PT.[MotherVitalStable] 
		,PT.[FoetalHeartRateDocumentScan] 
		,PT.[PlanForPregnencyContinue] 
	FROM Tbl_PNDTest PT 
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH (NOLOCK) ON  PT.[ANWSubjectId] = PPC.[ANWSubjectId]
	LEFT JOIN Tbl_PrePNDTScheduling PPS WITH (NOLOCK) ON PT.[ANWSubjectId] = PPS.[ANWSubjectId]
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
	AND PT.IsCompletePNDT = 0
	AND (@DistrictId = 0 OR SPD.[DistrictID] = @DistrictId)
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId)
	ORDER BY [GestationalAge] DESC
END

