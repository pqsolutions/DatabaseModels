USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddNewOTP' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddNewOTP
END
GO
CREATE PROCEDURE [dbo].[SPC_AddNewOTP]
(
	@Username VARCHAR(150)
	,@OTP VARCHAR(MAX)
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT 1 FROM Tbl_UserMaster WHERE Username=@Username)
		BEGIN
			UPDATE Tbl_UserMaster SET
				OTP=@OTP
				,OTPCreatedOn = GETDATE()
				,OTPExpiredOn = DATEADD(MI,5,GETDATE())
			WHERE UserName = @Username 

			SELECT 'OTP Sent Successfully' AS MSG ,1 AS MsgResponse
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