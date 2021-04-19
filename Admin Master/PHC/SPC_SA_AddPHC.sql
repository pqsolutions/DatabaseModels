--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddPHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddPHC
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddPHC] 
(	
	@CHCID INT
	,@PHC_gov_code VARCHAR(50)	
	,@PHCname VARCHAR(100)
	,@HNIN_ID VARCHAR(200)
	,@Pincode VARCHAR(150)
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @PHCname != '' OR @PHCname IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_PHCMaster WHERE PHCname= @PHCname AND CHCID = @CHCID)
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
				)VALUES(
				@CHCID
				,@PHC_gov_code				
				,@PHCname
				,@HNIN_ID
				,@Pincode
				,1
				,@Latitude
				,@Longitude
				,@Comments
				,@UserId
				,@UserId
				,GETDATE()
				,GETDATE()
				)
				
				SELECT (@PHCname + ' - PHC added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@PHCname + ' - PHC already exists') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'PHC Name is missing' AS Msg
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
