USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPrePostPNDTMTPAcknowledgement' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPrePostPNDTMTPAcknowledgement
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPrePostPNDTMTPAcknowledgement]
(
	@UniqueSubjectId VARCHAR(MAX)
	,@Request INT
)AS
BEGIN
	BEGIN TRY
		
		IF @Request = 1
		BEGIN
			IF EXISTS(SELECT ANWSubjectID FROM Tbl_PrePNDTCounselling  WHERE ANWSubjectId  = @UniqueSubjectId)
			BEGIN
				UPDATE Tbl_PrePNDTCounselling SET 
					UpdatedToANM = 1
				WHERE ANWSubjectId  = @UniqueSubjectId
			END
		END
		IF @Request = 2
		BEGIN
			IF EXISTS(SELECT ANWSubjectID FROM Tbl_PNDTest  WHERE ANWSubjectId  = @UniqueSubjectId)
			BEGIN
				UPDATE Tbl_PNDTest SET 
					UpdatedToANM = 1
				WHERE ANWSubjectId  = @UniqueSubjectId
			END
		END
		IF @Request = 3
		BEGIN
			IF EXISTS(SELECT ANWSubjectID FROM Tbl_PostPNDTCounselling  WHERE ANWSubjectId  = @UniqueSubjectId)
			BEGIN
				UPDATE Tbl_PostPNDTCounselling SET 
					UpdatedToANM = 1
				WHERE ANWSubjectId  = @UniqueSubjectId
			END
		END
		IF @Request = 4
		BEGIN
			IF EXISTS(SELECT ANWSubjectID FROM Tbl_MTPTest  WHERE ANWSubjectId  = @UniqueSubjectId)
			BEGIN
				UPDATE Tbl_MTPTest SET 
					UpdatedToANM = 1
				WHERE ANWSubjectId  = @UniqueSubjectId
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