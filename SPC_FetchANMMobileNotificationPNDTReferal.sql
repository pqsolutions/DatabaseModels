USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are PNDT Referal for ANM Mobile in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMMobileNotificationPNDTReferal' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMMobileNotificationPNDTReferal 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMMobileNotificationPNDTReferal] 
(
	@UserId INT
)
AS
BEGIN
	
	SELECT SP.[UniqueSubjectID] AS ANWSubjectId 
		,SP1.[UniqueSubjectID] AS SpouseSubjectId
		,SP.[FirstName] AS ANWFirstName
		,SP.[LastName] AS ANWLastName
		,SP1.[FirstName] AS SpouseFirstName
		,SP1.[LastName] AS SpouseLastName
		,SPR.[RCHID] 
		,SP.[MobileNo] AS ANWContactNo
		,SP1.[MobileNo] AS SpouseContactNo
		,CONVERT(VARCHAR,SPR.[LMP_Date],103) AS LMPDate
		,CAST((SELECT [dbo].[FN_CalculateGestationalAge](SPR.[SubjectID])) AS DECIMAL(18,1)) AS GestationalAge
		
		,CONVERT(VARCHAR,PPR.[PrePNDTCounsellingDate],103) AS PrePNDTCounsellingDate
		,CONVERT(VARCHAR(5),PPR.[PrePNDTCounsellingDate],108) AS PrePNDTCounsellingTime
		
		,CASE WHEN ISNULL(PPR.[PNDTScheduleDateTime],'') = '' THEN
		'' ELSE CONVERT(VARCHAR,PPR.[PNDTScheduleDateTime],103) END AS PNDTDate
		
		,CASE WHEN ISNULL(PPR.[PNDTScheduleDateTime],'') = '' THEN
		'' ELSE  CONVERT(VARCHAR(5),PPR.[PNDTScheduleDateTime],108) END AS PNDTTime
		
		,ISNULL(PPR.[IsNotified],0) AS NoitifiedStatus
		,PPR.[ID] AS PNDTReferalId
		
	FROM  Tbl_PrePNDTReferal PPR
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPR.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP1 WITH (NOLOCK) ON SP1.[UniqueSubjectID] = SP.[SpouseSubjectID] 
			  AND SP1.[UniqueSubjectID] = PPR.[SpouseSubjectId] 
	WHERE SP.[AssignANM_ID]  = @UserId   AND PPR.[IsNotified]  = 0 AND PPR.[IsPNDTCompleted] = 0 
	ORDER BY GestationalAge DESC	 		
	
END