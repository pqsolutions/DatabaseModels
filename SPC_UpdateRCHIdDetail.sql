--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateRCHIdDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateRCHIdDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateRCHIdDetail] 
(
	@OldRCHId VARCHAR(250)
	,@NewRCHId  VARCHAR(250)
	,@UserId INT
)
AS 
	DECLARE @SubjectId VARCHAR(MAX), @ExistSubjectId VARCHAR(MAX), 
	@Indexvar INT, @TotalCount INT, @CurrOldRch VARCHAR(250), @CurrNewRch VARCHAR(250),@OldRchSubString VARCHAR(50),@RCH VARCHAR(250)
	,@RevisedExistCheck INT = 0, @RCHUpdateCode VARCHAR(50) = '', @GetId INT, @GetId1 INT
BEGIN

	SET @IndexVar = 0  
	SELECT @TotalCount = COUNT(VALUE) FROM [dbo].[FN_Split](@OldRCHId,',')  
	WHILE @Indexvar < @TotalCount  
	BEGIN
		SELECT @IndexVar = @IndexVar + 1
		SELECT @CurrOldRch = VALUE FROM  [dbo].[FN_Split](@OldRCHId,',') WHERE id = @Indexvar
		SELECT  @SubjectId = UniqueSubjectId FROM Tbl_SubjectPregnancyDetail WHERE RCHID = @CurrOldRch ORDER BY ID DESC

		SELECT @CurrNewRch = VALUE FROM  [dbo].[FN_Split](@NewRCHId,',') WHERE id = @Indexvar

		IF EXISTS(SELECT ID FROM Tbl_SubjectPregnancyDetail WHERE RCHID = @CurrNewRch)
		BEGIN
			SET @RevisedExistCheck = 1
			SELECT @ExistSubjectId = UniqueSubjectId FROM Tbl_SubjectPregnancyDetail WHERE RCHID = @CurrNewRch ORDER BY ID DESC

			UPDATE Tbl_SubjectPregnancyDetail SET RCHID = (@CurrNewRch + '-ERR') WHERE UniqueSubjectID = @ExistSubjectId

			SELECT  @RCH = RCHID FROM Tbl_SubjectPregnancyDetail WHERE UniqueSubjectId = @ExistSubjectId 

			INSERT INTO [Tbl_RCHIdUpdationDetails](
				[UniqueSubjectId],
				[ExistRCHId],
				[NewRCHId],
				[CreatedBy],
				[CreatedOn])
				VALUES( 
				@ExistSubjectId
				,@CurrNewRch
				,@RCH
				,@UserId
				,GETDATE())
			SET @GetId = (SELECT SCOPE_IDENTITY())
			SET @RCHUpdateCode = @RCHUpdateCode + CONVERT(VARCHAR(10),@GetId) +','

		END

		UPDATE Tbl_SubjectPregnancyDetail SET RCHID = @CurrNewRch WHERE UniqueSubjectID = @SubjectId

		INSERT INTO [Tbl_RCHIdUpdationDetails](
			[UniqueSubjectId],
			[ExistRCHId],
			[NewRCHId],
			[CreatedBy],
			[CreatedOn])
		VALUES( 
			@ExistSubjectId
			,@CurrOldRch
			,@CurrNewRch
			,@UserId
			,GETDATE())

		SET @GetId1 = (SELECT SCOPE_IDENTITY())
		SET @RCHUpdateCode = @RCHUpdateCode + CONVERT(VARCHAR(10),@GetId1) +','
		SET @RCHUpdateCode =  LEFT(@RCHUpdateCode, LEN(@RCHUpdateCode) - 1)

	END

	SELECT 'RCH ID details updated successfully' AS MSG, @RevisedExistCheck AS RevisedExistCheck, @RCHUpdateCode AS RCHUpdateCode
END