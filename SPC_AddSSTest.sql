

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddSSTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddSSTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddSSTest] 
(
	@UniqueSubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@TestingCHCId INT
	,@IsPositive BIT
	,@CreatedBy INT
)
AS
DECLARE
	@SubjectId INT
BEGIN
	BEGIN TRY
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		
		INSERT INTO Tbl_SSTestResult(
			[UniqueSubjectID]
           ,[BarcodeNo]
           ,[TestingCHCId]
           ,[IsPositive]
           ,[SSTComplete]
           ,[CreatedOn]
           ,[CreatedBy])
		VALUES(
			@UniqueSubjectId 
			,@Barcode 
			,@TestingCHCId
			,@IsPositive 
			,1
			,GETDATE(),
			@CreatedBy)
			
		IF(@IsPositive = 1)
		BEGIN
			IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode )
			BEGIN
				UPDATE Tbl_PositiveResultSubjectsDetail SET 
					SSTStatus  = 'P'
					,SSTUpdatedOn = GETDATE()
					,IsActive = 1
				WHERE BarcodeNo = @Barcode 
			END
			ELSE
			BEGIN
				INSERT INTO Tbl_PositiveResultSubjectsDetail(
					SubjectID 
					,UniqueSubjectID
					,BarcodeNo
					,SSTStatus 
					,SSTUpdatedOn
					,IsActive)
				VALUES(
					@SubjectId
					,@UniqueSubjectId
					,@Barcode
					,'P'
					,GETDATE()
					,1)	
			END
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