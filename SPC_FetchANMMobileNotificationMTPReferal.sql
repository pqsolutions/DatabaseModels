USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are MTP Referal for ANM Mobile in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMMobileNotificationMTPReferal' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMMobileNotificationMTPReferal 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMMobileNotificationMTPReferal] 
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
		
		,CONVERT(VARCHAR,MTPR.[PostPNDTCounsellingDate],103) AS PostPNDTCounsellingDate
		,CONVERT(VARCHAR(5),MTPR.[PostPNDTCounsellingDate],108) AS PostPNDTCounsellingTime
		
		,CASE WHEN ISNULL(MTPR.[MTPScheduleDateTime],'') = '' THEN
		'' ELSE CONVERT(VARCHAR,MTPR.[MTPScheduleDateTime],103) END AS MTPDate
		
		,CASE WHEN ISNULL(MTPR.[MTPScheduleDateTime],'') = '' THEN
		'' ELSE  CONVERT(VARCHAR(5),MTPR.[MTPScheduleDateTime],108) END AS MTPTime
		
		,ISNULL(MTPR.[IsNotified],0) AS NoitifiedStatus
		,MTPR.[ID] AS MTPReferalId
		
	FROM  Tbl_MTPReferal MTPR
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MTPR.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP1 WITH (NOLOCK) ON SP1.[UniqueSubjectID] = SP.[SpouseSubjectID] 
			  AND SP1.[UniqueSubjectID] = MTPR.[SpouseSubjectId] 
	WHERE SP.[AssignANM_ID]  = @UserId   AND MTPR.[IsNotified]  = 0 AND MTPR.[IsMTPCompleted] = 0 
	ORDER BY GestationalAge DESC	 		
	
END