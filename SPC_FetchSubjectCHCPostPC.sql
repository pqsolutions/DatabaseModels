USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are PostPNDTCounselling for CHC 

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSubjectCHCPostPC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSubjectCHCPostPC 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchSubjectCHCPostPC] 
(
	@UserId INT
)
AS
DECLARE @CHCID INT,  @RegisterdFrom INT
BEGIN
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserId)
	SET @RegisterdFrom =(SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom')
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,PPS.[CounsellingDateTime],103) AS PostPNDTCounsellingDate
		,CONVERT(VARCHAR(5),PPS.[CounsellingDateTime],108) AS PostPNDTCounsellingTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS CounsellorName
		,PPC.[CounsellingRemarks]  AS CounsellingNotes
		,CASE WHEN PPC.[IsMTPTestdAgreedYes] = 1 THEN  'The couple has agreed for MTP service' 
		 WHEN PPC.[IsMTPTestdAgreedNo] = 1 THEN 'The couple hasn''t agreed for MTP service' 
		 WHEN  PPC.[IsMTPTestdAgreedPending]  = 1 THEN 'Couple''s decision awaited for Prenatal Diagnosis Test' 
		 END AS CounsellingStatus
		,CASE WHEN ISNULL(PPC.[IsMTPTestdAgreedYes],0) = 1 THEN 'YES' ELSE 'NO' END AS AgreeForMTP
	FROM  Tbl_PostPNDTCounselling PPC
	LEFT JOIN [dbo].[Tbl_PostPNDTScheduling]  PPS WITH (NOLOCK) ON PPS.[ANWSubjectId] = PPC.[ANWSubjectId] 
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = PPC.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = PPC.[CounsellorId] 
	WHERE SP.[CHCID]  = @CHCID  AND SP.[RegisteredFrom] = @RegisterdFrom 
	ORDER BY SP.[UniqueSubjectID] 
END