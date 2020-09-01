

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddCBCTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddCBCTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddCBCTest] 
(
	@UniqueSubjectId VARCHAR(250)
	,@Barcode VARCHAR(250)
	,@TestingCHCId INT
	,@MCV DECIMAL(18,2)
	,@RDW DECIMAL(18,2)
	,@TestCompleteOn VARCHAR(250)
	,@SampleDateTime VARCHAR(250)
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
			------------New logic added for expiry-----------------------
			SET @HoursDiff = (SELECT DATEDIFF(HH,CONVERT(DATETIME,@SampleDateTime,103) ,CONVERT(DATETIME,@TestCompleteOn,103)) HoursDifference)
				
			 IF @HoursDiff > 24 
			 BEGIN
				UPDATE Tbl_SampleCollection SET 
					SampleTimeoutExpiry = 1
					,UpdatedBy = @CreatedBy 
					,UpdatedOn = GETDATE()
					,RejectAt = 'CBC Test'
					,IsAccept = 0
				WHERE BarcodeNo = @Barcode 
			 END
		 --------------------------------------------------------
		END
		
		SET @HoursDiff = (SELECT DATEDIFF(HH,CONVERT(DATETIME,@SampleDateTime,103) ,CONVERT(DATETIME,@TestCompleteOn,103)) HoursDifference)
		IF @HoursDiff > 24 
		BEGIN
			SET @IsActive = 0
		END
		ELSE
		BEGIN
			SET @IsActive = 1
		END
		IF EXISTS(SELECT 1 FROM Tbl_PositiveResultSubjectsDetail WHERE BarcodeNo = @Barcode )
		BEGIN
			UPDATE Tbl_PositiveResultSubjectsDetail SET 
				CBCStatus = @CBCStatus 
				,CBCResult = @CBCResult 
				,CBCUpdatedOn = GETDATE()
				,IsActive = @IsActive 
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
				)VALUES(
				@SubjectId
				,@UniqueSubjectId
				,@Barcode
				,@CBCResult
				,@CBCStatus 
				,GETDATE()
				,@IsActive)				
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