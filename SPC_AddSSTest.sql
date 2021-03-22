

--USE [Eduquaydb]
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
	,@SSTStatus CHAR(1)
BEGIN
	BEGIN TRY
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		
		IF NOT EXISTS (SELECT 1 FROM Tbl_SSTestResult WHERE BarcodeNo = @Barcode )
		BEGIN
			INSERT INTO Tbl_SSTestResult(
				[UniqueSubjectID]
			   ,[BarcodeNo]
			   ,[TestingCHCId]
			   ,[IsPositive]
			   ,[SSTComplete]
			   ,[CreatedOn]
			   ,[CreatedBy]
			   ,[UpdatedBy]
			   ,[UpdatedOn])
			VALUES(
				@UniqueSubjectId 
				,@Barcode 
				,@TestingCHCId
				,@IsPositive 
				,1
				,GETDATE()
				,@CreatedBy
				,@CreatedBy
				,GETDATE())
		END
			
		IF @IsPositive = 1
		BEGIN
			SET @SSTStatus = 'P'
		END
		ELSE
		BEGIN
			SET @SSTStatus = 'N'
		END
		IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode AND UniqueSubjectID = @UniqueSubjectId)
		BEGIN
			UPDATE Tbl_PositiveResultSubjectsDetail SET 
				SSTStatus  = @SSTStatus
				,SSTUpdatedOn = GETDATE()
				,UpdatedToANM = 0
			WHERE BarcodeNo = @Barcode AND UniqueSubjectID = @UniqueSubjectId
		END
		ELSE
		BEGIN
			INSERT INTO Tbl_PositiveResultSubjectsDetail(
				SubjectID 
				,UniqueSubjectID
				,BarcodeNo
				,SSTStatus 
				,SSTUpdatedOn
				,IsActive
				,UpdatedToANM)
			VALUES(
				@SubjectId
				,@UniqueSubjectId
				,@Barcode
				,@SSTStatus
				,GETDATE()
				,1
				,0)	
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