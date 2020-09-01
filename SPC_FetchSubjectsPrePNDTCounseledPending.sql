USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPrePNDTCounseledPending' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPrePNDTCounseledPending
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPrePNDTCounseledPending] 
(
	  @UserId INT
	 ,@DistrictId INT
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
		,(SELECT [dbo].[FN_CalculateGestationalAge](SPD.[ID])) AS [GestationalAge]
		,SPD.[AssignANM_ID] 
		,SPD.[Age]
		,SPR.[ECNumber] 
		,(CONVERT(VARCHAR,SPR.[LMP_Date],103))AS LMPDate
		,PPC.[ID]  AS CounsellingId
		,PPC.[PrePNDTSchedulingId] AS SchedulingId
		,PPC.[CounsellorId] 
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
		,PPC.[AssignedObstetricianId]	
		,(UM1.[FirstName] +' '+UM1.[LastName] ) AS ObsetricianName
		,CONVERT(VARCHAR,PPC.[SchedulePNDTDate],103) AS SchedulePNDTDate
		,CONVERT(VARCHAR(5),PPC.[SchedulePNDTTime]) AS SchedulePNDTTime
		,PPC.[CounsellingRemarks] 
		,PPC.[FileName]
		,PPC.[FileData]
		,PPC.[IsPNDTAgreeYes]
		,PPC.[IsPNDTAgreeNo]
		,PPC.[IsPNDTAgreePending]
	FROM Tbl_PositiveResultSubjectsDetail PRSD
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PRSD.[UniqueSubjectID] 
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID] 
	LEFT JOIN Tbl_PrePNDTScheduling PPS WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PPS.[ANWSubjectId]
	LEFT JOIN Tbl_PrePNDTCounselling PPC WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PPC.[ANWSubjectId]
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPC.[CounsellorId] = UM.[ID]
	LEFT JOIN Tbl_UserMaster UM1 WITH(NOLOCK) ON PPC.[AssignedObstetricianId] = UM1.[ID] 
	WHERE SPD.[UniqueSubjectID] IN (SELECT UniqueSubjectID FROM Tbl_PositiveResultSubjectsDetail WHERE HPLCStatus ='P' AND IsActive = 1) 
	AND SPD.[SpouseSubjectID] IN (SELECT UniqueSubjectID FROM Tbl_PositiveResultSubjectsDetail WHERE HPLCStatus ='P' AND IsActive = 1)
	AND PRSD.[IsActive]  = 1
	AND  (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPC.[ANWSubjectId] NOT IN(SELECT ANWSubjectId FROM Tbl_PNDTest) AND PPC.[IsPNDTAgreePending] = 1 AND PPC.[IsActive] = 1
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId)
	AND (SELECT [dbo].[FN_CalculateGestationalAgeBySubId](PPC.[ANWSubjectId])) <= 30
END

