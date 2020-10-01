USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are PrePNDTCounselling for ANM Mobile

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMMobilePrePNDTCounselling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMMobilePrePNDTCounselling 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMMobilePrePNDTCounselling] 
(
	@UserId INT
)
AS
BEGIN
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) AS PrePNDTCounsellingDate
		,CONVERT(VARCHAR(5),PPS.[CounsellingDateTime],108) AS PrePNDTCounsellingTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS CounsellorName
		,PPC.[CounsellingRemarks]  AS CounsellingNotes
		,CASE WHEN PPC.[IsPNDTAgreeYes] = 1 THEN  'The couple has agreed for Pre-natal Diagnosis Test' 
		 WHEN PPC.[IsPNDTAgreeNo] = 1 THEN 'The couple hasn''t agreed for Pre-natal Diagnosis Test' 
		 WHEN  PPC.[IsPNDTAgreePending]  = 1 THEN 'Couple''s decision awaited for Prenatal Diagnosis Test' 
		 END AS CounsellingStatus
		,CASE WHEN ISNULL(PPC.[IsPNDTAgreeYes],0) = 1 THEN 'YES' ELSE 'NO' END  AS AgreeForPNDT
	FROM  Tbl_PrePNDTCounselling PPC
	LEFT JOIN [dbo].[Tbl_PrePNDTScheduling]  PPS WITH (NOLOCK) ON PPS.[ANWSubjectId] = PPC.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPC.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = PPC.[CounsellorId] 
	WHERE SP.[AssignANM_ID]  = @UserId   AND PPC.[UpdatedToANM]  = 1  
	ORDER BY SP.[UniqueSubjectID] 
END