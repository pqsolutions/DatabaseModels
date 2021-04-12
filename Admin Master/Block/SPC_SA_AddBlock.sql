--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddBlock' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddBlock
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddBlock] 
(	
	@Block_gov_code VARCHAR(50)
	,@Blockname VARCHAR(100)
	,@DistrictID INT
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @Blockname != '' OR @Blockname IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_BlockMaster WHERE Blockname= @Blockname AND DistrictID = @DistrictID)
			BEGIN
				INSERT INTO Tbl_BlockMaster (
					Block_gov_code
					,DistrictID
					,Blockname
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				VALUES(
				@Block_gov_code
				,@DistrictID
				,@Blockname
				,1
				,@Comments
				,@UserId
				,@UserId
				,GETDATE()
				,GETDATE()
				)
				SELECT (@Blockname + ' - Block added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@Blockname + ' - Block already exists') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'Block Name is missing' AS Msg
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
