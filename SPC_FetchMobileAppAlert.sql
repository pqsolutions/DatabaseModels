USE Eduquaydb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileAppAlert' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileAppAlert 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileAppAlert] 
AS 
BEGIN 
	SELECT ID
		,AlertMsg
	FROM Tbl_MobileAppAlert 
	WHERE Isactive = 1
END