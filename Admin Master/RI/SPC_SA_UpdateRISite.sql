--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateRISite' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateRISite
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateRISite] 
(	
	@Id INT
	,@CHCID INT
	,@PHCID INT
	,@SCID INT
	,@RI_gov_code VARCHAR(50)	
	,@RISite VARCHAR(100)
	,@Pincode VARCHAR(150)
	,@ILRId INT
	,@TestingCHCId INT
	,@IsActive BIT
	,@Comments VARCHAR(150)
	,@Latitude VARCHAR(150) = NULL
	,@Longitude VARCHAR(150) = NULL
	,@UserId INT
	
) AS
DECLARE @getId INT
BEGIN
	BEGIN TRY
		IF @RISite != '' OR @RISite IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT 1 FROM Tbl_RIMaster WHERE ID= @Id)
			BEGIN
				UPDATE Tbl_RIMaster SET 
					CHCID = @CHCID	
					,PHCID = @PHCID			
					,SCID = @SCID				
					,TestingCHCID = @TestingCHCId
					,RI_gov_code = @RI_gov_code
					,RIsite = @RISite 
					,ILRID = @ILRId
					,Pincode = @Pincode
					,Isactive = @Isactive
					,Latitude = @Latitude
					,Longitude = @Longitude
					,Comments = @Comments
					,Updatedby = @UserId
					,Updatedon = GETDATE()
				WHERE ID = @Id
				
				SELECT (@RISite + ' - RI Site updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid RI Site') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'RI site is missing' AS Msg
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
