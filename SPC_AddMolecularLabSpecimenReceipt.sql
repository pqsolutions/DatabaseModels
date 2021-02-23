--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddMolecularLabSpecimenReceipt' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddMolecularLabSpecimenReceipt
END
GO
CREATE PROCEDURE [dbo].[SPC_AddMolecularLabSpecimenReceipt]
(	
	@ShipmentId VARCHAR(250)
	,@ReceivedDate VARCHAR(300)
	,@SampleDamaged BIT
	,@BarcodeDamaged BIT
	,@IsAccept BIT
	,@PNDTFoetusId INT
	,@UpdatedBy INT
) AS
BEGIN
	BEGIN TRY
		
		UPDATE Tbl_PNDTShipments SET 
				ReceivedDateTime =CONVERT(DATETIME,@ReceivedDate,103)  
				,UpdatedBy = @UpdatedBy 
				,UpdatedOn = GETDATE()
		WHERE LTRIM(RTRIM(GenratedShipmentID)) = LTRIM(RTRIM(@ShipmentId))
		
		UPDATE Tbl_PNDTShipmentsDetail SET 
				SampleDamaged = @SampleDamaged
				,BarcodeDamaged = @BarcodeDamaged
				,IsAccept = @IsAccept 
		WHERE  PNDTFoetusId= @PNDTFoetusId
		
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