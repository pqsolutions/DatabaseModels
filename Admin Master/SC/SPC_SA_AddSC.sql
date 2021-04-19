--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddSC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddSC
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddSC] 
(	
	@CHCID INT
	,@PHCID INT
	,@SC_gov_code VARCHAR(50)	
	,@SCname VARCHAR(100)
	,@HNIN_ID VARCHAR(200)
	,@Pincode VARCHAR(150)
	,@SCAddress VARCHAR(MAX)
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @SCname != '' OR @SCname IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_SCMaster WHERE SCname= @SCname AND CHCID = @CHCID)
			BEGIN
				INSERT INTO Tbl_SCMaster (
					CHCID
					,PHCID
					,SC_gov_code					
					,SCname
					,HNIN_ID
					,Pincode
					,SCAddress
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
					,@PHCID
					,@SC_gov_code				
					,@SCname
					,@HNIN_ID
					,@Pincode
					,@SCAddress
					,1
					,@Latitude
					,@Longitude
					,@Comments
					,@UserId
					,@UserId
					,GETDATE()
					,GETDATE())
				
				SELECT (@SCname + ' - SC added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@SCname + ' - SC already exists') AS Msg
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
