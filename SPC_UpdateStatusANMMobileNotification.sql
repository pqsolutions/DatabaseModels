--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Update the Status in ANM Mobile notification Damaged Samples and Sample Timeout

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdateStatusANMMobileNotification' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdateStatusANMMobileNotification
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdateStatusANMMobileNotification]
(	
	@BarcodeNo VARCHAR(MAX)
	,@ANMID INT
	,@NotifiedOn VARCHAR(200)
)
AS
BEGIN
	BEGIN TRY
		UPDATE Tbl_SampleCollection SET 
			NotifiedStatus = 1
			,UpdatedBy = @ANMID
			,UpdatedOn = GETDATE()
			,NotifiedOn = CONVERT(DATETIME,@NotifiedOn,103)
		WHERE BarcodeNo = @BarcodeNo
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
