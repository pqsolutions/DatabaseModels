--USE [Eduquaydb]
GO

/****** Object:  StoredProcedure [dbo].[SPC_AddCHC]    Script Date: 03/25/2020 22:42:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT  1 FROM sys.objects WHERE name='SPC_AddCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddCHC
END
GO

CREATE PROCEDURE [dbo].[SPC_AddCHC]
(	
	@DistrictID INT
	,@BlockID INT
	,@HNIN_ID VARCHAR(200)
	,@CHC_gov_code VARCHAR(50)	
	,@CHCname VARCHAR(100)
	,@Istestingfacility  BIT
	,@TestingCHCID INT
	,@CentralLabId INT
	,@Pincode VARCHAR(150)
	,@Isactive  BIT
	,@Latitude VARCHAR(150)
	,@Longitude VARCHAR(150)
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
	
) AS
Declare
	@chcCount INT
	,@id INT
	,@tempUserId INT
	,@getId INT
BEGIN
	BEGIN TRY
		IF @CHC_gov_code !='' OR  @CHC_gov_code IS NOT NULL
		BEGIN
			SELECT @chcCount =  count(ID) FROM Tbl_CHCMaster WHERE CHC_gov_code = @CHC_gov_code
			SELECT @id= ID from Tbl_CHCMaster WHERE CHC_gov_code = @CHC_gov_code
			IF(@chcCount <= 0)
			BEGIN
				INSERT INTO Tbl_CHCMaster (
					BlockID
					,DistrictID
					,CHC_gov_code					
					,CHCname
					,Istestingfacility
					,CentralLabId
					,HNIN_ID
					,Pincode
					,Isactive
					,Latitude
					,Longitude
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@BlockID
				,@DistrictID
				,@CHC_gov_code				
				,@CHCname
				,@Istestingfacility
				,@CentralLabId
				,@HNIN_ID
				,@Pincode
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SET @getId =( SELECT SCOPE_IDENTITY())
				IF @Istestingfacility = 1
				BEGIN
					UPDATE Tbl_CHCMaster SET TestingCHCID = @getId  WHERE ID = @getId 
				END
				SELECT 'CHC added successfully' AS Msg
				
			END
			ELSE
			BEGIN
				UPDATE Tbl_CHCMaster SET 
				BlockID = @BlockID	
				,DistrictID = @DistrictID			
				,CHC_gov_code = @CHC_gov_code				
				,CHCname = @CHCname
				,Istestingfacility = @Istestingfacility
				,TestingCHCID = @TestingCHCID 
				,CentralLabId = @CentralLabId 
				,HNIN_ID = @HNIN_ID
				,Pincode = @Pincode
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @id
				
				IF @Istestingfacility = 1
				BEGIN
					UPDATE Tbl_CHCMaster SET TestingCHCID = @id  WHERE ID = @id 
				END
				SELECT 'CHC updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'CHC code is missing' AS Msg
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

GO


