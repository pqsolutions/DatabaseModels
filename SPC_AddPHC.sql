--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddPHC]    Script Date: 03/25/2020 23:53:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME='SPC_AddPHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPHC
END
GO
CREATE PROC [dbo].[SPC_AddPHC]
(	
	@CHCID INT
	,@HNIN_ID VARCHAR(200)
	,@PHC_gov_code VARCHAR(50)	
	,@PHCname VARCHAR(100)
	,@Pincode VARCHAR(150)
	,@Isactive  BIT
	,@Latitude VARCHAR(150)
	,@Longitude VARCHAR(150)
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) AS
DECLARE
	@phcCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF  @PHC_gov_code != '' OR @PHC_gov_code IS NOT NULL
		BEGIN
			SELECT @phcCount =  COUNT(ID) FROM Tbl_PHCMaster WHERE PHC_gov_code= @PHC_gov_code
			SELECT @ID= ID FROM Tbl_PHCMaster WHERE PHC_gov_code= @PHC_gov_code
			IF(@phcCount <= 0)
			BEGIN
				INSERT INTO Tbl_PHCMaster (
					CHCID
					,PHC_gov_code					
					,PHCname					
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
				@CHCID
				,@PHC_gov_code				
				,@PHCname
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
				SELECT 'PHC added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_PHCMaster set 
				CHCID = @CHCID								
				,PHC_gov_code = @PHC_gov_code				
				,PHCname = @PHCname
				,HNIN_ID = @HNIN_ID
				,Pincode = @Pincode
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'PHC updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'PHC Gov code is missing' AS Msg
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
