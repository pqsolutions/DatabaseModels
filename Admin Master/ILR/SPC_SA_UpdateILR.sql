--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_UpdateILR' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_UpdateILR
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_UpdateILR] 
(	
	@Id INT
	,@CHCID INT
	,@ILRCode VARCHAR(50)	
	,@ILRPoint VARCHAR(100)
	,@IsActive BIT
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @ILRPoint != '' OR @ILRPoint IS  NOT NULL 
		BEGIN
			IF  EXISTS (SELECT  1 FROM Tbl_ILRMaster WHERE Id = @Id)
			BEGIN
				
				UPDATE Tbl_ILRMaster SET 
					CHCID = @CHCID	
					,ILRCode = @ILRCode				
					,ILRPoint = @ILRPoint
					,Isactive = @Isactive
					,Comments = @Comments
					,Updatedby = @UserId
					,Updatedon = GETDATE()
				WHERE ID = @Id
				
				SELECT (@ILRPoint + ' - ILR Point updated successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT ('Please select valid ILR Point') AS Msg
			END
		END
		ELSE
		BEGIN
			SELECT 'ILR is missing' AS Msg
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
