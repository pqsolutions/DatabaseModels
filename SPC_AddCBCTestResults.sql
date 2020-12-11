

--USE [Eduquaydb]
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
	,@ConfirmStatus INT
	,@TestedId INT
	,@TestingCHCId INT
	,@CreatedBy INT
)
AS
DECLARE 
	@IsPositive BIT
	,@CBCResult VARCHAR(MAX)
	,@SubjectId INT
	,@CBCStatus CHAR(1)
	,@IsActive BIT
	,@Barcode VARCHAR(250)
	,@MCV DECIMAL(18,2)
	,@RDW DECIMAL(18,2)
	,@RBC DECIMAL(18,2)
	,@TestCompleteOn DATETIME

BEGIN
	BEGIN TRY
		SELECT @Barcode =  Barcode, @MCV = MCV, @RDW = RDW ,@RBC = RBC , @TestCompleteOn= TestedDateTime  FROM Tbl_CBCTestedDetail WHERE ID = @TestedId
		SELECT @SubjectId = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId 
		IF(@MCV < 80 AND @RDW < 16)
		BEGIN
			SET @IsPositive = 1
			SET @CBCResult = 'CBC Positive'
			SET @CBCStatus = 'P'
		END
		ELSE
		BEGIN
		SET @IsPositive = 0
			SET @CBCResult = 'CBC Negative'
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
			WHERE  Barcode = @Barcode AND TestedDateTime <= @TestCompleteOn
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
			WHERE TesteddateTime <= @TestCompleteOn AND ProcessStatus=0 AND
			ConfirmationStatus IS NULL AND  Barcode = @Barcode 

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
			WHERE  ID = @TestedId

			Update Tbl_CBCTestedDetail SET
				ProcessStatus = 1
				,ConfirmationStatus = 2
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			WHERE ID != @TestedId AND ProcessStatus=0 AND
			ConfirmationStatus IS NULL AND  Barcode = @Barcode 

			IF NOT EXISTS (SELECT 1 FROM Tbl_CBCTestResult WHERE BarcodeNo = @Barcode )
			BEGIN
				INSERT INTO Tbl_CBCTestResult(
					[UniqueSubjectID]
				   ,[BarcodeNo]
				   ,[TestingCHCId]
				   ,[MCV]
				   ,[RDW]
				   ,[RBC]
				   ,[IsPositive]
				   ,[CBCResult]
				   ,[CBCTestComplete]
				   ,[CreatedOn]
				   ,[CreatedBy]
				   ,[TestCompleteOn]
				   ,[CBCTestedDetailId]
				   ,[UpdatedBy]
				   ,[UpdatedOn])
					VALUES(
					@UniqueSubjectId 
					,@Barcode 
					,@TestingCHCId
					,@MCV
					,@RDW
					,@RBC
					,@IsPositive 
					,@CBCResult 
					,1
					,GETDATE()
					,@CreatedBy
					,@TestCompleteOn
					,@TestedId
					,@CreatedBy
					,GETDATE())
			END
			IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode )
			BEGIN
				UPDATE Tbl_PositiveResultSubjectsDetail SET 
					CBCStatus = @CBCStatus 
					,CBCResult = @CBCResult 
					,CBCUpdatedOn = @TestCompleteOn
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
					,@TestCompleteOn
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