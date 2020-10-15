USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_VerifyOTP' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_VerifyOTP
END
GO
CREATE PROCEDURE [dbo].[SPC_VerifyOTP]
(
	@Username VARCHAR(150)
	,@OTP VARCHAR(MAX)
)
AS
	DECLARE @CheckOTP INT, @OTPExpiredTime DATETIME    
BEGIN
	SELECT @CheckOTP = OTP , @OTPExpiredTime = OTPExpiredOn  FROM Tbl_UserMaster WHERE UserName=@Username 
	
	IF  @CheckOTP = @OTP
	BEGIN
		IF @OTPExpiredTime >= GETDATE()   
		BEGIN
			SELECT 'OTP Verified' AS MSG, 1 AS MsgResponse
		END
		ELSE
		BEGIN
			SELECT 'OTP Time Expired, Resend OTP' AS MSG, 0 AS MsgResponse
		END
	END
	ELSE
	BEGIN
		SELECT 'Invalid OTP' AS MSG, 0 AS MsgResponse
	END

END
