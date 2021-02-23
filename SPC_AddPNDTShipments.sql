--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPNDTShipments' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPNDTShipments
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPNDTShipments]
(
	@PNDTFoetusId VARCHAR(250)
	,@SenderName VARCHAR(250)
	,@SenderContact VARCHAR(250)
	,@SendingLocation VARCHAR(250)
	,@ReceivingMolecularLabId INT
	,@ShipmentDateTime VARCHAR(200)
	,@PDNTLocationId INT
	,@UserId INT
)
AS
DECLARE 
	@GeneratedShipmentID VARCHAR(200)
	,@ShipmentID INT
	,@Indexvar INT  
	,@TotalCount INT  
	,@CurrentIndexFoetusId NVARCHAR(200)
	,@BNO VARCHAR(MAX)=''
	,@SampleRefId NVARCHAR(250)
	,@PNDTestId INT
BEGIN
	BEGIN TRY
		IF @PNDTFoetusId IS NOT NULL
		BEGIN
			IF EXISTS (SELECT Value FROM [dbo].[FN_Split](@PNDTFoetusId,',') WHERE Value  IN (SELECT PNDTFoetusId FROM Tbl_PNDTShipmentsDetail))
			BEGIN
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@PNDTFoetusId,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndexFoetusId = Value FROM  [dbo].[FN_Split](@PNDTFoetusId,',') WHERE id = @Indexvar
					IF EXISTS( SELECT PNDTFoetusId FROM Tbl_PNDTShipmentsDetail WHERE PNDTFoetusId = @CurrentIndexFoetusId)
					BEGIN
						SET @SampleRefId = (SELECT SampleRefId FROM Tbl_PNDTFoetusDetail WHERE Id = CAST(@CurrentIndexFoetusId AS INT))
						SELECT @BNO += @SampleRefId + ','
					END
				END
				SELECT @BNO =  LEFT(@BNO, LEN(@BNO) - 1)
				
				SELECT 'The SampleRefId''s '+ @BNO +' already exist in previous shipment' AS ErrorMessage
				PRINT 'x'
			END
			ELSE
			BEGIN

				SET @GeneratedShipmentID = (SELECT  [dbo].[FN_GeneratePNDTShipmentId](@PDNTLocationId))
				INSERT INTO Tbl_PNDTShipments
					(GenratedShipmentID
					,SenderName
					,SenderContact
					,SenderLocation
					,ReceivingMolecularLabId
					,ShipmentDateTime
					,PNDTLocationId
					,CreatedBy
					,CreatedOn
					,UpdatedBy
					,UpdatedOn)
				VALUES
					(@GeneratedShipmentID
					,@SenderName
					,@SenderContact
					,@SendingLocation
					,@ReceivingMolecularLabId
					,CONVERT(DATETIME,@ShipmentDateTime,103)
					,@PDNTLocationId
					,@UserId 
					,GETDATE()
					,@UserId
					,GETDATE())

				SET @ShipmentID = (SELECT SCOPE_IDENTITY())
				
				CREATE  TABLE #TempTable(TempCol NVARCHAR(250), ArrayIndex INT)
				INSERT INTO #TempTable(TempCol,ArrayIndex) (SELECT Value,id FROM dbo.FN_Split(@PNDTFoetusId,','))
				
				SET @IndexVar = 0  
				SELECT @TotalCount= COUNT(*) FROM #TempTable  
				WHILE @Indexvar < @TotalCount  
				BEGIN 
					 SELECT @Indexvar  = @Indexvar + 1 
					 SELECT @CurrentIndexFoetusId = TempCol FROM #TempTable WHERE ArrayIndex = @Indexvar
					 SELECT @PNDTestId = PNDTestId FROM Tbl_PNDTFoetusDetail WHERE Id = @CurrentIndexFoetusId
					 INSERT INTO Tbl_PNDTShipmentsDetail (ShipmentId,PNDTestId,PNDTFoetusId)  
					 VALUES(@ShipmentID,@PNDTestId,@CurrentIndexFoetusId)
				END
				DROP TABLE #TempTable
				
				SELECT @GeneratedShipmentID AS ShipmentID 
				
				PRINT 'y'
			
			END
		END
		ELSE
		BEGIN
			SELECT 'The SampleRefId are not select in this shipment' AS ErrorMessage
			PRINT 'z'
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