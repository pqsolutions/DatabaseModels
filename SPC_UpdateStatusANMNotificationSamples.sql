USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Update the Status in ANM notification Damaged Samples and Sample Timout

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateStatusANMNotificationSamples' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateStatusANMNotificationSamples
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateStatusANMNotificationSamples]
(	
	@ID INT
	,@Status INT
	,@ANMID INT
	,@Scope_output INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		IF @ID != null
		BEGIN
			UPDATE Tbl_SampleCollection SET 
			NotifiedStatus = @Status
			,UpdatedBy = @ANMID
			,UpdatedOn = GETDATE()
			,NotifiedOn = GETDATE()
			WHERE ID = @ID
			SET @Scope_output = 1
		END
		ELSE
		BEGIN
			SET @Scope_output = -1
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
