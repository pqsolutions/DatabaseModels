--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateCHC] 
(	
	@Id INT
	,@DistrictID INT
	,@BlockID INT
	,@HNIN_ID VARCHAR(200)
	,@CHC_gov_code VARCHAR(50)	
	,@CHCname VARCHAR(100)
	,@Istestingfacility  BIT
	,@TestingCHCID INT
	,@CentralLabId INT
	,@Pincode VARCHAR(150)
	,@Isactive  BIT
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
DECLARE @getId INT
BEGIN
	BEGIN TRY
		IF @CHCname != '' OR @CHCname IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT 1 FROM Tbl_CHCMaster WHERE ID= @Id)
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
					,Updatedby = @UserId
					,Updatedon = GETDATE()
				WHERE ID = @Id

				IF @Istestingfacility = 1
				BEGIN
					UPDATE Tbl_CHCMaster SET TestingCHCID = @TestingCHCID  WHERE ID = @Id 
				END
				SELECT (@CHCname + ' - CHC updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid chc') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'CHC Name is missing' AS Msg
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
