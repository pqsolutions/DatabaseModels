USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateStagingHPLCTestDetails' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateStagingHPLCTestDetails 
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateStagingHPLCTestDetails] 
(
	@HPLCTestId INT
	,@HbF DECIMAL(10,3)
	,@HbA0 DECIMAL(10,3)
	,@HbA2 DECIMAL(10,3)
	,@HbS DECIMAL(10,3)
	,@HbD DECIMAL(10,3)
	,@UserId INT
)
AS
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
		WHERE ID = @HPLCTestId
		SELECT    'HPLC test result updated successfully' AS MSG

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