USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileLoginStatus1' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileLoginStatus1
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileLoginStatu1]
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
				SELECT @Device = DeviceId, @LoginStatus = LoginStatus, @LastLoginFrom = LastLoginFrom FROM Tbl_ANMLogin WHERE UserName = @UserName
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
					SET @Msg = 'This user '+ @UserName  +' already logged in ' + @LastLoginFrom
					SELECT 0 AS Allow, @Msg AS Msg
					PRINT 'C'
				END
				ELSE IF @Device = @DeviceId  AND @LoginStatus = 0
				BEGIN
					UPDATE Tbl_ANMLogin SET 
						DeviceId = @DeviceId
						,LoginStatus = 1
						,LastLoginFrom = 'TAB'
						,LastLoginDate = GETDATE()
					WHERE ANMId = @ANMId 
					SELECT 1 AS Allow , '' AS Msg
					PRINT 'D'
				END
				ELSE IF  @Device =  @DeviceId AND @LoginStatus = 1
				BEGIN
					SET @Msg = 'This user '+ @UserName  +' already logged in this ' + @LastLoginFrom
					SELECT 0 AS Allow, @Msg AS Msg
					PRINT 'E'
				END
				ELSE IF  @Device !=  @DeviceId AND @LoginStatus = 0
				BEGIN
					SELECT 0 AS Allow, 'Invalid deviceid' AS Msg
					PRINT 'F'
				END
				ELSE IF  @Device !=  @DeviceId AND @LoginStatus = 1
				BEGIN
					SELECT 0 AS Allow, 'Invalid deviceid' AS Msg
					PRINT 'G'
				END
			END
		END
		ELSE
		BEGIN
			SELECT 0 AS Allow, 'User not exist' AS Msg
			PRINT 'H'
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