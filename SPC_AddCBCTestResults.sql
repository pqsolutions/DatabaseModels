

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddCBCTestResults' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddCBCTestResults 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddCBCTestResults] 
(
	@UniqueSubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@TestingCHCId INT
	,@MCV DECIMAL(18,2)
	,@RDW DECIMAL(18,2)
	,@TestCompleteOn VARCHAR(250)
	,@SampleDateTime VARCHAR(250)
	,@ConfirmStatus INT
	,@CreatedBy INT
)
AS
DECLARE 
	@IsPositive BIT
	,@CBCResult VARCHAR(MAX)
	,@SubjectId INT
	,@CBCStatus CHAR(1)
	,@HoursDiff INT  -- New logic added for expire
	,@IsActive BIT
BEGIN
	BEGIN TRY
		
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		IF(@MCV < 80 AND @RDW < 16)
		BEGIN
			SET @IsPositive = 1
			SET @CBCResult = 'Screening Test Positive'
			SET @CBCStatus = 'P'
		END
		ELSE
		BEGIN
		SET @IsPositive = 0
			SET @CBCResult = 'Screening Test Negative'
			SET @CBCStatus = 'N'
		END

		IF @ConfirmStatus = 3
		BEGIN
			SET @IsActive = 0

			Update Tbl_CBCTestedDetail SET
				ProcessStatus = 1
				,ConfirmationStatus = 3
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE  Barcode = @Barcode 
			AND ProcessStatus=0 AND ConfirmationStatus IS NULL

			UPDATE Tbl_SampleCollection SET 
				SampleTimeoutExpiry = 1
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
				,RejectAt = 'CBC Test'
				,IsAccept = 0
			WHERE BarcodeNo = @Barcode 

			IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode )
			BEGIN
				UPDATE Tbl_PositiveResultSubjectsDetail SET 
					CBCStatus = NULL 
					,CBCResult = 'Sample Timeout' 
					,CBCUpdatedOn = GETDATE()
					,IsActive = @IsActive 
					,UpdatedToANM = 0
				WHERE BarcodeNo = @Barcode 
			END
			
			SELECT  ('Barcode ' + @Barcode + ' - Sample  Timedout Successfully') AS MSG


		END
		ELSE IF @ConfirmStatus = 2
		BEGIN
			Update Tbl_CBCTestedDetail SET
				ProcessStatus = 1
				,ConfirmationStatus = 2
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE  Barcode = @Barcode  
			AND ProcessStatus=0 AND ConfirmationStatus IS NULL

			SELECT  ('Barcode ' + @Barcode + ' - Re-run Sample Again') AS MSG

		END
		ELSE IF @ConfirmStatus = 1
		BEGIN
			SET @IsActive = 1

			Update Tbl_CBCTestedDetail SET
				ProcessStatus = 1
				,ConfirmationStatus = 1
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE  Barcode = @Barcode AND TestedDateTime = CONVERT(DATETIME,@TestCompleteOn,103) 
			AND ProcessStatus=0 AND ConfirmationStatus IS NULL

			IF NOT EXISTS (SELECT 1 FROM Tbl_CBCTestResult WHERE BarcodeNo = @Barcode )
			BEGIN
				INSERT INTO Tbl_CBCTestResult(
					[UniqueSubjectID]
				   ,[BarcodeNo]
				   ,[TestingCHCId]
				   ,[MCV]
				   ,[RDW]
				   ,[IsPositive]
				   ,[CBCResult]
				   ,[CBCTestComplete]
				   ,[CreatedOn]
				   ,[CreatedBy]
				   ,[TestCompleteOn])
					VALUES(
					@UniqueSubjectId 
					,@Barcode 
					,@TestingCHCId
					,@MCV
					,@RDW
					,@IsPositive 
					,@CBCResult 
					,1
					,GETDATE()
					,@CreatedBy
					,CONVERT(DATETIME,@TestCompleteOn,103)
					)
			END
			IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode )
			BEGIN
				UPDATE Tbl_PositiveResultSubjectsDetail SET 
					CBCStatus = @CBCStatus 
					,CBCResult = @CBCResult 
					,CBCUpdatedOn = CONVERT(DATETIME,@TestCompleteOn,103)
					,IsActive = @IsActive 
					,UpdatedToANM = 0
				WHERE BarcodeNo = @Barcode 
			END
			ELSE
			BEGIN
			
				INSERT INTO Tbl_PositiveResultSubjectsDetail(
					SubjectID 
					,UniqueSubjectID
					,BarcodeNo
					,CBCResult
					,CBCStatus 
					,CBCUpdatedOn
					,IsActive
					,UpdatedToANM
					)VALUES(
					@SubjectId
					,@UniqueSubjectId
					,@Barcode
					,@CBCResult
					,@CBCStatus 
					,CONVERT(DATETIME,@TestCompleteOn,103)
					,@IsActive
					,0)				
			END
				SELECT   ('Barcode ' + @Barcode + ' - Sample CBC test result updated successfully') AS MSG
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