--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateBlock' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateBlock
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateBlock] 
(	
	@Id INT
	,@Block_gov_code VARCHAR(50)
	,@Blockname VARCHAR(100)
	,@DistrictID INT
	,@Isactive BIT
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @Blockname != '' OR @Blockname IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT 1 FROM Tbl_BlockMaster WHERE ID= @Id)
			BEGIN
				UPDATE Tbl_BlockMaster SET 
				Block_gov_code = @Block_gov_code
				,Blockname = @Blockname
				,DistrictID = @DistrictID
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @UserId
				,Updatedon = GETDATE()
				WHERE ID = @Id
				SELECT ('Block details updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid block') AS Msg
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
