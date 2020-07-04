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
	@BarcodeNo VARCHAR(MAX)
	,@ANMID INT
)
AS
DECLARE @Indexvar INT  
DECLARE @TotalCount INT  
DECLARE @CurrentIndexBarcode NVARCHAR(200)
BEGIN
	BEGIN TRY
		SET @IndexVar = 0  
		SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@BarcodeNo,',')  
		WHILE @Indexvar < @TotalCount  
		BEGIN	
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentIndexBarcode = Value FROM  [dbo].[FN_Split](@BarcodeNo,',') WHERE id = @Indexvar
			UPDATE Tbl_SampleCollection SET 
				NotifiedStatus = 1
				,UpdatedBy = @ANMID
				,UpdatedOn = GETDATE()
				,NotifiedOn = GETDATE()
			WHERE BarcodeNo = @CurrentIndexBarcode
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
