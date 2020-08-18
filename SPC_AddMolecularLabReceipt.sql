USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularLabReceipt' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularLabReceipt
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularLabReceipt]
(	
	@ShipmentId VARCHAR(250)
	,@ReceivedDate VARCHAR(300)
	,@SampleDamaged BIT
	,@BarcodeDamaged BIT
	,@IsAccept BIT
	,@Barcode VARCHAR(200)
	,@UpdatedBy INT
) AS
DECLARE
	@RejectAt VARCHAR(100)
BEGIN
	BEGIN TRY
		SET @RejectAt = NULL
		
		IF @IsAccept = 0
		BEGIN
			SET @RejectAt = 'Molecular Lab Receipt'
		END
		
	
		UPDATE Tbl_CentralLabShipments SET 
				ReceivedDate =CONVERT(DATETIME,@ReceivedDate,103)  
				,UpdatedBy = @UpdatedBy 
				,UpdatedOn = GETDATE()
		WHERE LTRIM(RTRIM(GenratedShipmentID)) = LTRIM(RTRIM(@ShipmentId))
		
		UPDATE Tbl_SampleCollection SET
				SampleDamaged = @SampleDamaged 
				,BarcodeDamaged = @BarcodeDamaged
				,IsAccept = @IsAccept 
				,RejectAt = @RejectAt 
				,UpdatedBy = @UpdatedBy 
				,UpdatedOn = GETDATE()
		WHERE  LTRIM(RTRIM(BarcodeNo)) = LTRIM(RTRIM(@Barcode))
	
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