USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Fetch Details of particular subject for sample collection

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMCHCSampleSubjectDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMCHCSampleSubjectDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMCHCSampleSubjectDetail]
(	
	@ID INT
)
AS
DECLARE 
	@ReasonId INT
	,@Reason VARCHAR(100)
BEGIN
	SET @Reason = 'First Time Collection'
	SET @ReasonId = (SELECT ID FROM  Tbl_ConstantValues WHERE CommonName = @Reason)
	
	
	SELECT SP.[ID] 
		   ,SP.[UniqueSubjectID] 
		   ,(SP.[FirstName] + ' ' + SP.[MiddleName] + ' ' + SP.[LastName]) AS SubjectName
		   ,SPR.[RCHID]
		   ,@ReasonId AS ReasonId
		   ,@Reason AS Reason
	FROM  Tbl_SubjectPrimaryDetail SP
	LEFT JOIN Tbl_SubjectPregnancyDetail SPR WITH (NOLOCK) ON SPR.ID = SP.ID	
	WHERE SP.[ID]  = @ID
END
