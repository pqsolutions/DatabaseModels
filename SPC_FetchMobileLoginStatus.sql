USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileLoginStatus' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileLoginStatus
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileLoginStatus]
(	
	@ANMId INT
	,@UserName VARCHAR(250)
	,@DeviceId VARCHAR(MAX)
)
AS
	DECLARE	@LoginStatus BIT
			,@LastLoginFrom VARCHAR(50)
			,@LastLoginDate DATETIME
			,@Device VARCHAR(MAX)
			,@Msg VARCHAR(MAX)
BEGIN
	BEGIN TRY
		IF  EXISTS(SELECT 1 FROM Tbl_UserMaster WHERE Username = @UserName AND ID =@ANMId )
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM Tbl_ANMLogin WHERE  UserName = @UserName)
			BEGIN
				INSERT INTO Tbl_ANMLogin(ANMId,UserName,DeviceId,LoginStatus,LastLoginFrom,LastLoginDate)
				VALUES(@ANMId,@UserName,@DeviceId,1,'TAB',GETDATE()) 
				
				SELECT 1 AS Allow,'' AS Msg
				PRINT 'A'
			END
			ELSE
			BEGIN
				SELECT @Device = DeviceId, @LoginStatus = LoginStatus, @LastLoginFrom = LastLoginFrom, @LastLoginDate = LastLoginDate
				FROM Tbl_ANMLogin WHERE UserName = @UserName
				IF @Device = '' AND @LoginStatus = 0
				BEGIN
					UPDATE Tbl_ANMLogin SET 
						DeviceId = @DeviceId
						,LoginStatus = 1
						,LastLoginFrom = 'TAB'
						,LastLoginDate = GETDATE()
					WHERE ANMId = @ANMId 
					SELECT 1 AS Allow, '' AS Msg
					PRINT 'B'
				END
				ELSE IF  @Device = '' AND @LoginStatus = 1
				BEGIN
					SET @Msg = 'Welcome '+ @UserName + ' !!!   You are already logged in a PC !!! If you have any pending data in the PC,  please Save / Submit and log OFF from the PC to avoid data loss and then Login here.  If you still want to continue, Press RESET Login button below to clear earlier TAB and then Login in here.'
					SELECT 0 AS Allow, @Msg AS Msg
					PRINT 'C'
				END
				ELSE IF  @Device =  @DeviceId AND @LoginStatus = 1
				BEGIN
					SET @Msg = 'Welcome '+ @UserName + ' !!!   You are already logged in a same TAB because of some issue!!! Try reset login to continue logging here.'
					SELECT 0 AS Allow, @Msg AS Msg
					PRINT 'D'
				END
				
				ELSE IF  @Device !=  @DeviceId AND @LoginStatus = 1
				BEGIN
					SET @Msg = 'Welcome '+ @UserName + ' !!!   You are already logged in another TABLET !!! If you have any pending data in that TAB,  please SYNC & Log OFF from that TABLET to avoid data loss and then Login here.  If you still want to continue, Press RESET Login button below to clear earlier TAB and then Login in here.'
					SELECT 0 AS Allow, @Msg AS Msg
					PRINT 'E'
				END
			END
		END
		ELSE
		BEGIN
			SELECT 0 AS Allow, 'User does not exist' AS Msg
			PRINT 'F'
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