USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddANMShipment' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddANMShipment
END
GO
CREATE PROCEDURE [dbo].[SPC_AddANMShipment]
(	
	@SubjectID INT
	,@UniqueSubjectID VARCHAR(200)
	,@SampleCollectionID INT
	,@ShipmentFrom VARCHAR(20)
	,@ShipmentID VARCHAR(200)
	,@ANM_ID INT
	,@TestingCHCID INT
	,@RIID INT
	,@ILR_ID INT
	,@AVDID INT
	,@ContactNo VARCHAR(150)
	,@DateofShipment VARCHAR(100)
	,@TimeofShipment VARCHAR(100)
	,@CreatedBy INT
	,@Scope_output INT OUTPUT
) AS
DECLARE
	@sCount INT
	,@tempId int
BEGIN
	BEGIN TRY
		IF @SubjectID != 0 OR @SubjectID IS NOT NULL OR @ShipmentID != '' OR @ShipmentID IS NOT NULL
		BEGIN
			SELECT @sCount =  count(ID) FROM Tbl_ANMShipment 
			WHERE SubjectID = @SubjectID AND SampleCollectionID = @SampleCollectionID 
			AND ShipmentFrom = @ShipmentFrom AND ShipmentID = @ShipmentID
			
			IF(@sCount <= 0)
			BEGIN
				INSERT INTO Tbl_ANMShipment
					  (SubjectID
					  ,UniqueSubjectID
					  ,SampleCollectionID
					  ,ShipmentFrom
					  ,ShipmentID     
					  ,ANM_ID
					  ,TestingCHCID
					  ,RIID
					  ,ILR_ID
					  ,AVDID
					  ,ContactNo
					  ,DateofShipment
					  ,TimeofShipment
					  ,CreatedBy
					  ,CreatedOn
					  )VALUES
					  (@SubjectID
					  ,@UniqueSubjectID
					  ,@SampleCollectionID
					  ,@ShipmentFrom
					  ,@ShipmentID
					  ,@ANM_ID     
					  ,@TestingCHCID
					  ,@RIID
					  ,@ILR_ID 
					  ,@AVDID
					  ,@ContactNo
					  ,CONVERT(DATE,@DateofShipment,103)
					  ,CONVERT(TIME(0),@TimeofShipment)
					  ,@CreatedBy
					  ,GETDATE())
				SET @tempId = IDENT_CURRENT('Tbl_Shipment')
				SET @Scope_output = 1
			END
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