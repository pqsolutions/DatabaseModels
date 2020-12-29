--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddSubjectPregnancyDetail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddSubjectPregnancyDetail 
End
GO
CREATE PROCEDURE [dbo].[SPC_AddSubjectPregnancyDetail]
(
	@UniqueSubjectID VARCHAR(200)
	,@RCHID  VARCHAR(150)
	,@ECNumber  VARCHAR(150)
	,@LMP_Date  VARCHAR(150)
	,@G INT
	,@P INT
	,@L INT
	,@A INT
	,@UpdatedBy INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@SubCount INT
	,@SubjectID  INT
	,@tempUserId INT
	,@LMP DATE
	,@SubjectType INT
	,@ChildSubjectType INT
	,@SpouseSubjectID VARCHAR(250)
BEGIN
	BEGIN TRY
		IF @UniqueSubjectID IS NOT NULL
		BEGIN
			SELECT @SubCount =  COUNT(ID) FROM Tbl_SubjectPregnancyDetail WHERE UniqueSubjectID = @UniqueSubjectID
			SELECT @SubjectID =   ID, @SubjectType = SubjectTypeID, @ChildSubjectType = ChildSubjectTypeID, 
			@SpouseSubjectID = SpouseSubjectID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectID
			SET @LMP = CONVERT(DATE,@LMP_Date,103)
			IF ISNULL(@LMP_Date,'')= ''
			BEGIN
				SET @LMP = NULL
			END
			IF (@SubCount <= 0) 
			BEGIN
				INSERT INTO [dbo].[Tbl_SubjectPregnancyDetail]
					(SubjectID
					,UniqueSubjectID
					,RCHID
					,ECNumber
					,LMP_Date
					,G
					,P
					,L
					,A
					,UpdatedBy
					,UpdatedOn)
				VALUES
					(@SubjectID
					,@UniqueSubjectID 
					,@RCHID
					,@ECNumber
					,@LMP
					,@G  
					,@P  
					,@L  
					,@A  
					,@UpdatedBy 
					,GETDATE() )
					
				IF @SubjectType = 2 OR @ChildSubjectType = 2
				BEGIN
					UPDATE Tbl_SubjectPregnancyDetail  SET 
						ECNumber = @ECNumber
						,UpdatedBy = @UpdatedBy
						,UpdatedOn = GETDATE()
				WHERE  UniqueSubjectID  = @SpouseSubjectID 
				END	
				SET @tempUserId = IDENT_CURRENT('Tbl_SubjectPregnancyDetail')
				SET @Scope_output = 1
			END
			ELSE 
			BEGIN
				UPDATE [dbo].[Tbl_SubjectPregnancyDetail]
				   SET ECNumber = @ECNumber
					  ,LMP_Date = @LMP
					  ,G = @G
					  ,P = @P
					  ,L = @L
					  ,A = @A
					  ,UpdatedBy = @UpdatedBy
					  ,UpdatedOn = GETDATE()
				WHERE UniqueSubjectID = @UniqueSubjectID
				
				IF @SubjectType = 2 OR @ChildSubjectType = 2 OR  @SubjectType = 1 OR @ChildSubjectType = 1
				BEGIN
					UPDATE Tbl_SubjectPregnancyDetail  SET
						ECNumber = @ECNumber
						,UpdatedBy = @UpdatedBy
					    ,UpdatedOn = GETDATE()
					WHERE  UniqueSubjectID  = @SpouseSubjectID 
				END
				
				SET @Scope_output = 1
			END
		END
		ELSE
		BEGIN		
			SET @Scope_output = -1
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			DECLARE @ErrorNumber INT = ERROR_NUMBER();
			DECLARE @ErrorLine INT = ERROR_LINE();
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();

			PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	END CATCH
END

