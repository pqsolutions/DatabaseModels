USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are Post MTP Follow Up in DC Notification

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDCPostMTPFollowUp' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDCPostMTPFollowUp 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchDCPostMTPFollowUp] 
(
	@DistrictId INT
)
AS
BEGIN
	
	SELECT SP.[UniqueSubjectID] AS ANWSubjectId 
		,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS ANWSubjectName
		,SPR.[RCHID] 
		,SP.[MobileNo] AS ANWContactNo
		,SP.[AssignANM_ID] 
		,CM.[CHCname] 
		,(UMO.[FirstName] + ' ' + UMO.[LastName]) AS ANMName
		,UMO.[ContactNo1]  AS ANMContactNo
		,(CONVERT(VARCHAR,MT.[MTPDateTime],103) + ' ' + CONVERT(VARCHAR,MT.[MTPDateTime],108)) AS MTPDateTime
		,CASE WHEN  ISNULL(MT.[FirstFollowupStatusId],0) = 0 THEN 'Pending' ELSE 'Completed' END AS FirstFollowup
		,CASE WHEN  ISNULL(MT.[SecondFollowupStatusId],0) = 0 THEN 'Pending' ELSE 'Completed' END AS SecondFollowup
		,CASE WHEN  ISNULL(MT.[ThirdFollowupStatusId],0) = 0 THEN 'Pending' ELSE 'Completed' END AS ThirdFollowup
		,ISNULL(MT.FollowUpStatus,0) AS FollowUpStatus
		,MT.[ID] AS MTPID 
	FROM  Tbl_MTPTest MT
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MT.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPregnancyDetail]  SPR WITH (NOLOCK) ON SPR.[SubjectID] = SP.[ID]
	LEFT JOIN [dbo].[Tbl_UserMaster] UMO WITH (NOLOCK) ON UMO.[ID] = SP.[AssignANM_ID] 
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.[ID] = SP.[CHCID]  
	
	WHERE SP.[DistrictID]  = @DistrictId    AND MT.[IsActive]   = 1  AND ISNULL(MT.[FollowUpStatus],0) = 0
	AND (ISNULL(MT.[IsFirstFollowupCompleted],0) = 0 OR ISNULL(MT.[IsSecondFollowupCompleted],0) = 0  OR ISNULL(MT.[IsThirdFollowupCompleted],0) = 0)
	AND ISNULL(MT.[FirstFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	AND ISNULL(MT.[SecondFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	AND ISNULL(MT.[ThirdFollowupStatusId],0) != (SELECT ID FROM Tbl_MTPFollowUpMaster WHERE StatusName = 'Expired')
	
END