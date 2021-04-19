--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdatePHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdatePHC
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdatePHC] 
(	
	@Id INT
	,@CHCID INT
	,@PHC_gov_code VARCHAR(50)	
	,@PHCname VARCHAR(100)
	,@HNIN_ID VARCHAR(200)
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
		IF @PHCname != '' OR @PHCname IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT 1 FROM Tbl_PHCMaster WHERE ID= @Id)
			BEGIN
				UPDATE Tbl_PHCMaster SET 
					CHCID = @CHCID	
					,PHC_gov_code = @PHC_gov_code				
					,PHCname = @PHCname
					,HNIN_ID = @HNIN_ID
					,Pincode = @Pincode
					,Isactive = @Isactive
					,Latitude = @Latitude
					,Longitude = @Longitude
					,Comments = @Comments
					,Updatedby = @UserId
					,Updatedon = GETDATE()
				WHERE ID = @Id
				
				SELECT (@PHCname + ' - PHC updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid phc') AS Msg
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
