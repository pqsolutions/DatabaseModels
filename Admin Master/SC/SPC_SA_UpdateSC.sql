--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateSC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateSC
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateSC] 
(	
	@Id INT
	,@CHCID INT
	,@PHCID INT
	,@SC_gov_code VARCHAR(50)	
	,@SCname VARCHAR(100)
	,@HNIN_ID VARCHAR(200)
	,@Pincode VARCHAR(150)
	,@SCAddress VARCHAR(MAX)
	,@Isactive  BIT
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @SCname != '' OR @SCname IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT 1 FROM Tbl_SCMaster WHERE ID= @Id)
			BEGIN
				UPDATE Tbl_SCMaster SET 
					CHCID = @CHCID	
					,PHCID = @PHCID	
					,SC_gov_code = @SC_gov_code				
					,SCname = @SCname
					,HNIN_ID = @HNIN_ID
					,Pincode = @Pincode
					,SCAddress = @SCAddress
					,Isactive = @Isactive
					,Latitude = @Latitude
					,Longitude = @Longitude
					,Comments = @Comments
					,Updatedby = @UserId
					,Updatedon = GETDATE()
				WHERE ID = @Id
				
				SELECT (@SCname + ' - SC updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid sc') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'SC Name is missing' AS Msg
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
