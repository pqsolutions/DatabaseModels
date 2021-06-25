

--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddHPLCTestResults' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddHPLCTestResults 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddHPLCTestResults] 
(
	@UniqueSubjectId VARCHAR(250)
	,@CentralLabId INT
	,@HPLCTestId INT
	,@CreatedBy INT
)
AS
DECLARE 
	@IsNormal BIT
	,@SubjectId INT
	,@HbF DECIMAL(10,3)
	,@HbA0 DECIMAL(10,3)
	,@HbA2 DECIMAL(10,3)
	,@HbS DECIMAL(10,3)
	,@HbD DECIMAL(10,3)
	,@BarcodeNo VARCHAR(250)
	,@TestCompleteOn DATETIME
	,@InjectionNo VARCHAR(MAX)
	
BEGIN
	BEGIN TRY
		SELECT @BarcodeNo=Barcode, @HbA0 = HbA0, @HbA2 = HbA2, @HbF = HbF, @Hbs = HbS, @HbD = HbD,
		@TestCompleteOn = TestedDateTime, @InjectionNo = InjectionNo FROM Tbl_HPLCTestedDetail WHERE ID = @HPLCTestId

		SET @IsNormal = 1
		IF(@HbF >= 5.00 OR @HbA2 >= 3.38 OR  @HbS >= 5.00  OR  @HbD >= 5.00)
		BEGIN
			SET @IsNormal = 0
		END
		SELECT @SubjectID = ID FROM Tbl_SubjectPrimaryDetail WHERE UniqueSubjectID = @UniqueSubjectId
		IF NOT EXISTS (SELECT BarcodeNo FROM Tbl_HPLCTestResult WHERE BarcodeNo = @BarcodeNo)
		BEGIN
			INSERT INTO Tbl_HPLCTestResult(
				[SubjectID] 
			   ,[UniqueSubjectID]
			   ,[BarcodeNo]
			   ,[CentralLabId]
			   ,[HbF]
			   ,[HbA0]
			   ,[HbA2]
			   ,[HbS]
			   ,[HbC]
			   ,[HbD]
			   ,[IsNormal]
			   ,[HPLCTestComplete]
			   ,[HPLCTestCompletedOn]
			   ,[CreatedOn]
			   ,[CreatedBy]
			   ,[InjectionNo]
			   ,[UpdatedOn]
			   ,[UpdatedBy])
			VALUES(
				@SubjectID
			   ,@UniqueSubjectID
			   ,@BarcodeNo
			   ,@CentralLabId
			   ,@HbF
			   ,@HbA0
			   ,@HbA2
			   ,@HbS
			   ,0.00
			   ,@HbD
			   ,@IsNormal
			   ,1
			   ,@TestCompleteOn
			   ,GETDATE()
			   ,@CreatedBy
			   ,@InjectionNo
			   ,GETDATE()
			   ,@CreatedBy)

			   UPDATE Tbl_HPLCTestedDetail SET
				ProcessStatus = 1
				,SampleStatus = 1
				,ReasonOfStatus = 'Sample Confirmed and Processed'
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			   WHERE ID = @HPLCTestId

			 UPDATE Tbl_HPLCTestedDetail SET
				ProcessStatus = 1
				,SampleStatus = 2
				,ReasonOfStatus = 'Sample superseded or duplicate' 
				,UpdatedBy = @CreatedBy
				,UpdatedOn = GETDATE()
			   WHERE ID != @HPLCTestId AND ISNULL(ProcessStatus,0) = 0
			   AND SampleStatus IS NULL AND Barcode = @BarcodeNo

			SELECT   ('Barcode ' + @BarcodeNo + ' - Sample HPLC test result updated successfully') AS MSG, @IsNormal AS IsNormal
		END
		ELSE
		BEGIN
			SELECT   ('Barcode ' + @BarcodeNo + ' - Sample HPLC test result already updated') AS MSG
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