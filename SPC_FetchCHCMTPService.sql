USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Fetch Subject Details  which are MTP Service for CHC

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHCMTPService' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHCMTPService 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHCMTPService] 
(
	@UserId INT
)
AS
DECLARE @CHCID INT,  @RegisterdFrom INT
BEGIN
	SET @CHCID = (SELECT CHCID FROM Tbl_UserMaster WHERE ID = @UserId)
	SET @RegisterdFrom =(SELECT ID FROM Tbl_ConstantValues WHERE CommonName = 'CHC' AND comments = 'RegisterFrom')
	SELECT SP.[UniqueSubjectID] 
		,CONVERT(VARCHAR,MT.[MTPDateTime],103) AS MTPDate
		,CONVERT(VARCHAR(5),MT.[MTPDateTime],108) AS MTPTime
		,(UM.[FirstName] + ' ' + UM.[LastName]) AS CounsellorName
		,(UM1.[FirstName] + ' ' + UM1.[LastName]) AS ObstetricianName
		,MT.[ClinicalHistory] 
		,MT.[Examination] 
		,MT.[ProcedureofTesting]
		,DCM.[DischargeConditionName]
		,(SELECT [dbo].[FN_GetMTPSubjectComplications](MT.[ID])) AS MTPComplications
	FROM  Tbl_MTPTest MT
	LEFT JOIN [dbo].[Tbl_SubjectPrimaryDetail] SP WITH (NOLOCK) ON SP.[UniqueSubjectID] = MT.[ANWSubjectId]
	LEFT JOIN [dbo].[Tbl_UserMaster] UM WITH (NOLOCK) ON UM.[ID] = MT.[CounsellorId] 
	LEFT JOIN [dbo].[Tbl_UserMaster] UM1 WITH (NOLOCK) ON UM1.[ID] = MT.[ObstetricianId]  
	LEFT JOIN Tbl_DischargeConditionMaster DCM WITH (NOLOCK) ON DCM.[ID] = MT.[DischargeConditionId]  
	WHERE SP.[CHCID]  = @CHCID  AND SP.[RegisteredFrom] = @RegisterdFrom
	ORDER BY SP.[UniqueSubjectID] 
	
END