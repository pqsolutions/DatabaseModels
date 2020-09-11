USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddResultAcknowledgement' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddResultAcknowledgement
END
GO
CREATE PROCEDURE [dbo].[SPC_AddResultAcknowledgement]
(
	@UniqueSubjectId VARCHAR(MAX)
)AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT TOP 1 * FROM Tbl_PositiveResultSubjectsDetail WHERE UniqueSubjectID = @UniqueSubjectId ORDER BY ID DESC)
		BEGIN
			UPDATE Tbl_PositiveResultSubjectsDetail SET 
				UpdatedToANM = 1
			WHERE UniqueSubjectID = @UniqueSubjectId
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