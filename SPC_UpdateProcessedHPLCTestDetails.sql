USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateProcessedHPLCTestDetails' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateProcessedHPLCTestDetails 
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateProcessedHPLCTestDetails] 
(
	@BarcodeNo VARCHAR(250)
	,@HbF DECIMAL(10,3)
	,@HbA0 DECIMAL(10,3)
	,@HbA2 DECIMAL(10,3)
	,@HbS DECIMAL(10,3)
	,@HbD DECIMAL(10,3)
	,@UserId INT
)
AS
DECLARE 
	@IsNormal BIT
BEGIN
	BEGIN TRY
		UPDATE Tbl_HPLCTestedDetail SET
			HbF = @HbF
			,HbA0 = @HbA0
			,HbA2 = @HbA2
			,HbS = @HbS
			,HbD = @HbD
			,ValuesUpdatedOn = GETDATE()
			,ValuesUpdatedBy = @UserId
		WHERE Barcode = @BarcodeNo AND ProcessStatus = 1 AND SampleStatus = 1


		SET @IsNormal = 1
		IF(@HbF >= 5.00 OR @HbA2 >= 3.38 OR  @HbS >= 5.00  OR  @HbD >= 5.00)
		BEGIN
			SET @IsNormal = 0
		END

		UPDATE Tbl_HPLCTestResult SET
			HbF = @HbF
			,HbA0 = @HbA0
			,HbA2 = @HbA2
			,HbS = @HbS
			,HbD = @HbD
			,IsNormal = @IsNormal
			,UpdatedOn = GETDATE()
			,UpdatedBy = @UserId
		WHERE BarcodeNo = @BarcodeNo 


		SELECT 'HPLC processed test result updated successfully' AS MSG

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