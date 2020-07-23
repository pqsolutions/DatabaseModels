USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchWebLoginStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchWebLoginStatus 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchWebLoginStatus]
(	
	@ANMId INT
	,@UserName VARCHAR(250)
)
AS
	DECLARE	@LoginStatus BIT
			,@LastLoginFrom VARCHAR(50)
			,@LastLoginDate DATETIME
BEGIN
	BEGIN TRY
		IF  EXISTS(SELECT 1 FROM Tbl_UserMaster WHERE Username = @UserName AND ID = @ANMId)
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Tbl_ANMLogin WHERE  UserName = @UserName)
			BEGIN
				INSERT INTO Tbl_ANMLogin(ANMId,UserName,DeviceId,LoginStatus,LastLoginFrom,LastLoginDate)
				VALUES(@ANMId,@UserName,'',1,'WEB',GETDATE()) 
				
				SELECT 1 AS Allow,'' AS Msg
				PRINT 'A'
			END
			ELSE
			BEGIN
				SELECT @LoginStatus = LoginStatus FROM Tbl_ANMLogin WHERE UserName = @UserName
				IF @LoginStatus = 0
				BEGIN
					UPDATE Tbl_ANMLogin SET 
						DeviceId = ''
						,LoginStatus = 1
						,LastLoginFrom = 'WEB'
						,LastLoginDate = GETDATE()
					WHERE ANMId = @ANMId 
					SELECT 1 AS Allow, '' AS Msg
					PRINT 'B'
				END
				ELSE IF  @LoginStatus = 1
				BEGIN
					SELECT 0 AS Allow, 'Already login' AS Msg
					PRINT 'C'
				END
			END
		END
		ELSE
		BEGIN
			SELECT 0 AS Allow, 'User not exist' AS Msg
			PRINT 'D'
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