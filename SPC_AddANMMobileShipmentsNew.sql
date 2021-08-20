--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddANMMobileShipmentsNew' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddANMMobileShipmentsNew
END
GO
CREATE PROCEDURE [dbo].[SPC_AddANMMobileShipmentsNew]
(	
	@GeneratedShipmentId VARCHAR(250)
	,@BarcodeNo VARCHAR(MAX)	
	,@ShipmentFrom INT
	,@ANM_ID INT
	,@RIID INT
	,@ILR_ID INT
	,@AVDID INT
	,@AVDContactNo VARCHAR(150)
	,@AlternateAVD VARCHAR(250)
	,@AlternateAVDContactNo VARCHAR(250)
	,@TestingCHCID INT
	,@DateofShipment VARCHAR(100)
	,@TimeofShipment VARCHAR(100)
	,@CreatedBy INT
	,@Source CHAR(1)
) AS
DECLARE
	@UniqueSubjectId VARCHAR(250)
	,@ShipmentID INT
	,@Indexvar INT  
	,@TotalCount INT  
	,@CurrentIndexBarcode NVARCHAR(200)
	,@BNO VARCHAR(MAX)=''

BEGIN
	BEGIN TRY
		IF @BarcodeNo IS NOT NULL
		BEGIN
			
				SET @IndexVar = 0  
				SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](@BarcodeNo,',')  
				WHILE @Indexvar < @TotalCount  
				BEGIN
					SELECT @IndexVar = @IndexVar + 1
					SELECT @CurrentIndexBarcode = Value FROM  [dbo].[FN_Split](@BarcodeNo,',') WHERE id = @Indexvar
					IF EXISTS(SELECT BarcodeNo FROM Tbl_ANMCHCShipmentsDetail WHERE BarcodeNo = @CurrentIndexBarcode)
					BEGIN
						SET @BNO += (@CurrentIndexBarcode +'-ERR') + ','
					END
					ELSE
					BEGIN
						SET @BNO += @CurrentIndexBarcode + ','
					END

				END
				SELECT @BNO =  LEFT(@BNO, LEN(@BNO) - 1)
				
				INSERT INTO Tbl_ANMCHCShipments
					(ShipmentFrom
					,GenratedShipmentID
					,ANM_ID
					,RIID
					,ILR_ID
					,AVDID
					,AVDContactNo
					,AlternateAVD
					,AlternateAVDContactNo
					,TestingCHCID
					,DateofShipment
					,TimeofShipment
					,CreatedBy
					,CreatedOn
					,UpdatedBy
					,UpdatedOn)
				VALUES
					(@ShipmentFrom 
					,@GeneratedShipmentID
					,@ANM_ID
					,@RIID
					,@ILR_ID
					,@AVDID
					,@AVDContactNo
					,@AlternateAVD
					,@AlternateAVDContactNo
					,@TestingCHCID
					,CONVERT(DATE,@DateofShipment,103)
					,CONVERT(TIME(0),@TimeofShipment) 
					,@CreatedBy 
					,GETDATE()
					,@CreatedBy 
					,GETDATE())
					
				SET @ShipmentID = (SELECT ID FROM Tbl_ANMCHCShipments WHERE GenratedShipmentID = @GeneratedShipmentID)
				
				CREATE  TABLE #TempTable(TempCol NVARCHAR(250), ArrayIndex INT)
				INSERT INTO #TempTable(TempCol,ArrayIndex) (SELECT Value,id FROM dbo.FN_Split(@BNO,','))
				
				SET @IndexVar = 0  
				SELECT @TotalCount= COUNT(*) FROM #TempTable  
				WHILE @Indexvar < @TotalCount  
				BEGIN 
					 SELECT @Indexvar  = @Indexvar + 1 
					 SELECT @CurrentIndexBarcode = TempCol FROM #TempTable WHERE ArrayIndex = @Indexvar
					 SET  @UniqueSubjectId = (SELECT TOP 1 UniqueSubjectID FROM Tbl_SampleCollection WHERE BarcodeNo = @CurrentIndexBarcode AND CreatedBy = @CreatedBy ORDER BY ID DESC )
						INSERT INTO Tbl_ANMCHCShipmentsDetail (ShipmentId,UniqueSubjectId,BarcodeNo)  
						VALUES(@ShipmentID,@UniqueSubjectId,@CurrentIndexBarcode)
					SET @UniqueSubjectId=''
				END
				DROP TABLE #TempTable
			
			
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