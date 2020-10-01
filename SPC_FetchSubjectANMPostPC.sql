USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are PostPNDTCounselling for ANM 

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectANMPostPC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectANMPostPC 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectANMPostPC] 
(
	@UserId INT
)
AS
BEGIN
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) AS PostPNDTCounsellingDate
		,CONVERT(VARCHAR(5),PPS.[CounsellingDateTime],108) AS PostPNDTCounsellingTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS CounsellorName
		,PPC.[CounsellingRemarks]  AS CounsellingNotes
		,CASE WHEN PPC.[IsMTPTestdAgreedYes] = 1 THEN  'The couple has agreed for MTP service' 
		 WHEN PPC.[IsMTPTestdAgreedNo] = 1 THEN 'The couple hasn''t agreed for MTP service' 
		 WHEN  PPC.[IsMTPTestdAgreedPending]  = 1 THEN  'Couple''s decision awaited for Prenatal Diagnosis Test' 
		 END AS CounsellingStatus
		,CASE WHEN ISNULL(PPC.[IsMTPTestdAgreedYes],0) = 1 THEN 'YES' ELSE 'NO' END AS AgreeForMTP
	FROM  Tbl_PostPNDTCounselling PPC
	LEFT JOIN [dbo].[Tbl_PostPNDTScheduling]  PPS WITH (NOLOCK) ON PPS.[ANWSubjectId] = PPC.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPC.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = PPC.[CounsellorId] 
	WHERE SP.[AssignANM_ID]  = @UserId  
	ORDER BY SP.[UniqueSubjectID] 
END