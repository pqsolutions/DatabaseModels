--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddRISite' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddRISite
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddRISite] 
(	
	@CHCID INT
	,@PHCID INT
	,@SCID INT
	,@RI_gov_code VARCHAR(50)	
	,@RISite VARCHAR(100)
	,@Pincode VARCHAR(150)
	,@ILRId INT
	,@TestingCHCId INT
	,@Comments VARCHAR(150)
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @RISite != '' OR @RISite IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_RIMaster WHERE RISite= @RISite AND CHCID = @CHCID AND SCID = @SCID)
			BEGIN
				INSERT INTO Tbl_RIMaster (
					CHCID
					,PHCID
					,SCID
					,RI_gov_code					
					,RIsite
					,TestingCHCID
					,Pincode
					,ILRID
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
					,@SCID
					,@RI_gov_code				
					,@RISite
					,@TestingCHCId
					,@Pincode
					,@ILRId
					,1
					,@Latitude
					,@Longitude
					,@Comments
					,@UserId
					,@UserId
					,GETDATE()
					,GETDATE())
				
				SELECT @RISite AS Msg
			END
			ELSE
			BEGIN
				SELECT '' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT @RISite + ' RI Site is missing' AS Msg
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
