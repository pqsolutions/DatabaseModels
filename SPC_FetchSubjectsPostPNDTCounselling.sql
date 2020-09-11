USE [Eduquaydb]
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
		,SPR.[ECNumber] 
		,(CONVERT(VARCHAR,SPR.[LMP_Date],103))AS LMPDate
		,PRSD.[CBCResult] AS ANWCBCResult
		,CASE WHEN PRSD.[SSTStatus] = 'P' THEN 'Positive' ELSE 'Negative' END AS ANWSSTResult
		,PRSD.[HPLCTestResult] AS ANWHPLCResult
		,(SELECT Top 1 [CBCResult] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) AS SpouseCBCResult
		, CASE WHEN (SELECT TOP 1 [SSTStatus] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) = 'P' THEN 'Positive' ELSE 'Negative' END AS SpouseSSTResult
		,(SELECT TOP 1 [HPLCTestResult] FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = SPD.[SpouseSubjectID] 
			AND HPLCStatus ='P' AND IsActive = 1 ORDER BY ID DESC) AS SpouseHPLCResult
		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS PrePNDTCounsellorName
		,(CONVERT(VARCHAR,PPSS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PPSS.[CounsellingDateTime],103))) AS PrePNDTCounsellingDateTime
		  ,'The couple has agreed for Pre-natal Diagnosis' AS PreNDTCounsellingStatus
		  	,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] AS PrePNDTCounsellingRemarks
		
		,PT.[PNDTResultId] 
		,PRM.[ResultName] AS PNDTResults
		,CASE WHEN PRM.[IsPositive] = 1 THEN  1 ELSE 0 END AS FoetalDisease 
		,PT.[ObstetricianId] 
		,(UM2.[FirstName] +' '+UM2.[LastName] ) AS PNDTestObstetrician
		,(CONVERT(VARCHAR,PT.[UpdatedOn],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PT.[UpdatedOn],103))) AS PNDDateTime
		  ,PD.[DiagnosisName] AS PNDTDiagnosisName
		,PPS.[ID] AS PostPNDTSchedulingId
		,PPS.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS PostPNDTCounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PPS.[CounsellingDateTime],103))) AS CounsellingDateTime
	FROM Tbl_PostPNDTScheduling PPS
	LEFT JOIN Tbl_PNDTest PT WITH (NOLOCK) ON PPS.[ANWSubjectId] = PT.[ANWSubjectId] 
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH(NOLOCK) ON PPC.[ID] = PT.[PrePNDTCounsellingId]
	LEFT JOIN Tbl_PrePNDTScheduling  PPSS WITH(NOLOCK) ON PPSS.[ID] = PPC.[PrePNDTSchedulingId]  
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PT.[ANWSubjectId]
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID]
	LEFT JOIN Tbl_PositiveResultSubjectsDetail PRSD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PRSD.[UniqueSubjectID]
	LEFT JOIN Tbl_PNDTResultMaster  PRM WITH (NOLOCK) ON PRM.[ID] = PT.[PNDTResultId]
	LEFT JOIN Tbl_PNDTDiagnosisMaster PD WITH (NOLOCK) ON PD.[ID] = PT.[PNDTDiagnosisId] 
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPS.[CounsellorId] = UM.[ID] 
	LEFT JOIN Tbl_UserMaster UM1 WITH (NOLOCK) ON UM1.[ID] = PPC.[CounsellorId] 
	LEFT JOIN Tbl_UserMaster UM2 WITH (NOLOCK) ON UM2.[ID] = PT.[ObstetricianId]
	WHERE (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPS.[IsCounselled] = 0 
	AND SPD.[UniqueSubjectID] NOT IN (SELECT ANWSubjectId FROM Tbl_PostPNDTCounselling)
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId) 
	ORDER BY [GestationalAge] DESC 
END

