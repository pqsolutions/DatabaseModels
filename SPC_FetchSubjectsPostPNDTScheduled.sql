USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectsPostPNDTScheduled' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectsPostPNDTScheduled
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectsPostPNDTScheduled] 
(
	  @UserId INT
	 ,@DistrictId INT
	 ,@CHCId INT
	 ,@PHCId INT
	 ,@ANMId INT  
)
AS
BEGIN
	SELECT PPS.[ANWSubjectId] 
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
		,PPS.[ID] AS SchedulingId
		,PPS.[CounsellorId] 
		,(UM.[FirstName] +' '+UM.[LastName] ) AS CounsellorName
		,(CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) + ' ' +
		  CONVERT(VARCHAR(5),CONVERT(TIME(2),PPS.[CounsellingDateTime],103))) AS CounsellingDateTime
		,(CONVERT(VARCHAR,PT.[PNDTDateTime],103) + ' ' + CONVERT(VARCHAR(5),PT.[PNDTDateTime],108))AS PNDTDateTime
	FROM 	Tbl_PostPNDTScheduling PPS  
	LEFT JOIN Tbl_SubjectPrimaryDetail SPD WITH (NOLOCK) ON SPD.[UniqueSubjectID] = PPS.[ANWSubjectId]  
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPD.[UniqueSubjectID] = SPR.[UniqueSubjectID] 
	LEFT JOIN Tbl_UserMaster UM WITH(NOLOCK) ON PPS.[CounsellorId] = UM.[ID]
	LEFT JOIN Tbl_PNDTest PT WITH (NOLOCK) ON PPS.[ANWSubjectId] = PT.[ANWSubjectId] 
	WHERE (SPD.[SubjectTypeID] = 1 OR SPD.ChildSubjectTypeID =1)
	AND PPS.[IsCounselled] = 0 
	AND PPS.[ANWSubjectId] NOT IN (SELECT ANWSubjectId FROM Tbl_PostPNDTCounselling)
	AND (SPD.[DistrictID] = @DistrictId OR SPD.[DistrictID] IN (SELECT DistrictID FROM Tbl_UserDistrictMaster WHERE UserId = @UserId))
	AND (@CHCId = 0 OR SPD.[CHCID] = @CHCId)
	AND (@PHCId = 0 OR SPD.[PHCID] = @PHCId)
	AND (@ANMId = 0 OR SPD.[AssignANM_ID] = @ANMId)
	ORDER BY [GestationalAge] DESC   
END

