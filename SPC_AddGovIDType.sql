USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddGovIDType' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddGovIDType
END
GO
CREATE PROCEDURE [dbo].[SPC_AddGovIDType]
(	
	@GovIDType VARCHAR(100)
	,@Isactive  BIT
	,@Comments VARCHAR(150)
	,@Createdby INT
	,@Updatedby INT
) AS
DECLARE
	@gtCount INT
	,@ID INT
	,@tempUserId INT
BEGIN
	BEGIN TRY
		IF @GovIDType IS NOT NULL
		BEGIN
			SELECT @gtCount =  COUNT(ID) FROM Tbl_Gov_IDTypeMaster WHERE GovIDType = @GovIDType
			SELECT @ID =  ID FROM Tbl_Gov_IDTypeMaster WHERE GovIDType = GovIDType
			IF(@gtCount <= 0)
			BEGIN
				INSERT INTO Tbl_Gov_IDTypeMaster (
					GovIDType
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@GovIDType
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Gov Id Type added successfully' AS Msg
			END
			ELSE
			BEGIN
				UPDATE Tbl_Gov_IDTypeMaster SET 
				GovIDType = @GovIDType
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				WHERE ID = @ID
				SELECT 'Gov Id Type updated successfully' AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'Gov Id type is missing' AS Msg
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
