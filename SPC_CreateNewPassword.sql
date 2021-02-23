--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_CreateNewPassword' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_CreateNewPassword
END
GO
CREATE PROCEDURE [dbo].[SPC_CreateNewPassword]
(
	@Username VARCHAR(150)
	,@Password VARCHAR(MAX)
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM Tbl_UserMaster WHERE Username=@Username)
		BEGIN
			UPDATE Tbl_UserMaster SET
				password=@Password
			WHERE UserName = @Username 

			SELECT 'Password updated successfully, Please Login' AS MSG ,1 AS MsgResponse
		END
		ELSE
		BEGIN
			SELECT 'User does not exist' AS MSG ,0 AS MsgResponse
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