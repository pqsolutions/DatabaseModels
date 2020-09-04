USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_Logout' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_Logout 
END
GO
CREATE PROCEDURE [dbo].[SPC_Logout]
(	
	@ANMId INT
)
AS
	DECLARE @Allow BIT, @Msg VARCHAR(MAX)
BEGIN
	BEGIN TRY
		SET @Allow = 0
		SET @Msg = 'Invalid user'
		IF  EXISTS(SELECT 1 FROM Tbl_UserMaster WHERE Id = @ANMId )
		BEGIN
			UPDATE Tbl_ANMLogin SET DeviceId = '', LoginStatus = 0 WHERE  ANMId = @ANMId 
			Set @Allow = 1
			SET @Msg = 'Logout successfully'
			UPDATE Tbl_LoginDetails SET LogoutResetTime = GETDATE(),IsLogout = 1 
			WHERE  ID  = (SELECT TOP 1 ID FROM Tbl_LoginDetails WHERE UserId = @ANMId AND IsLogout IS NULL ORDER BY ID DESC)
		END
		SELECT @Allow AS Allow, @Msg as Msg
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