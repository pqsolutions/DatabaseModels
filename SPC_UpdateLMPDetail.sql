--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateLMPDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateLMPDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateLMPDetail] 
(
	@SubjectId  VARCHAR(250)
	,@OldLMP VARCHAR(250)
	,@NewLMP  VARCHAR(250)
	,@Remarks VARCHAR(MAX)
	,@UserId INT
)
AS 
	
BEGIN

	UPDATE Tbl_SubjectPregnancyDetail SET LMP_Date = CONVERT(DATE,@NewLMP,103),UpdatedOn=GETDATE(), UpdatedBy=@UserId WHERE UniqueSubjectID = @SubjectId

	INSERT INTO [dbo].[Tbl_LMPUpdationDetails](
		[UniqueSubjectId],
		[OLDLMP],
		[NewLMP],
		[Remarks],
		[CreatedBy],
		[CreatedOn])
	VALUES( 
		@SubjectId
		,CONVERT(DATE,@OldLMP,103)
		,CONVERT(DATE,@NewLMP,103)
		,@Remarks
		,@UserId
		,GETDATE())

	SELECT 'LMP details updated successfully' AS MSG
END