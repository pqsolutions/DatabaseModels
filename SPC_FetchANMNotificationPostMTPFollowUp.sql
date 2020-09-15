USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Post MTP Follow Up in Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMNotificationPostMTPFollowUp' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMNotificationPostMTPFollowUp 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMNotificationPostMTPFollowUp] 
(
	@UserId INT
)
AS
BEGIN
	
	SELECT SP.[UniqueSubjectID] AS ANWSubjectId 
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS ANWSubjectName
		,SPR.[RCHID] 
		,SP.[MobileNo] AS ANWContactNo
		,SP.[AssignANM_ID] 
		,(CONVERT(VARCHAR,MT.[MTPDateTime],103) + ' ' + CONVERT(VARCHAR,MT.[MTPDateTime],108)) AS MTPDateTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS ObstetritianName
		,1 AS FirstFollowupNo
		,ISNULL(MT.[FirstFollowupStatusId],0) AS FirstFollowup
		,ISNULL(MT.[FirstFollowupStatusDetail],'') AS FirstFollowupStatusDetail
		,2 AS SecondFollowupNo
		,ISNULL(MT.[SecondFollowupStatusId],0) AS SecondFollowup
		,ISNULL(MT.[SecondFollowupStatusDetail],'') AS SecondFollowupStatusDetail
		,3 AS ThirdFollowupNo
		,ISNULL(MT.[ThirdFollowupStatusId],0) AS ThirdFollowup
		,ISNULL(MT.[ThirdFollowupStatusDetail],'') AS ThirdFollowupStatusDetail
		,MT.[ID] AS MTPID 
	FROM  Tbl_MTPTest MT
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MT.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = MT.[ObstetricianId]
	WHERE SP.[AssignANM_ID]  = @UserId   AND MT.[IsActive]  = 1  
	AND (ISNULL(MT.[IsFirstFollowupCompleted],0) = 0 OR ISNULL(MT.[IsSecondFollowupCompleted],0) = 0  OR ISNULL(MT.[IsThirdFollowupCompleted],0) = 0)
	AND ISNULL(MT.[FirstFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	AND ISNULL(MT.[SecondFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	AND ISNULL(MT.[ThirdFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	
END