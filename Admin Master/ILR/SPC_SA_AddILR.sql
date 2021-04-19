--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_SA_AddILR' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_SA_AddILR
END
GO
CREATE PROCEDURE [dbo].[SPC_SA_AddILR] 
(	
	@CHCID INT
	,@ILRCode VARCHAR(50)	
	,@ILRPoint VARCHAR(100)
	,@Comments VARCHAR(150)
	,@UserId INT
	
) AS
BEGIN
	BEGIN TRY
		IF @ILRPoint != '' OR @ILRPoint IS  NOT NULL 
		BEGIN
			IF NOT EXISTS (SELECT   1 FROM Tbl_ILRMaster WHERE ILRPoint= @ILRPoint AND CHCID = @CHCID)
			BEGIN
				INSERT INTO Tbl_ILRMaster (
					CHCID
					,ILRCode					
					,ILRPoint
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				)VALUES(
					@CHCID
					,@ILRCode				
					,@ILRPoint
					,1
					,@Comments
					,@UserId
					,@UserId
					,GETDATE()
					,GETDATE())
				
				SELECT (@ILRPoint + ' - ILR Point added successfully') AS Msg
			END
			ELSE
			BEGIN
				SELECT (@ILRPoint + ' - ILR Point already exists') AS Msg
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
