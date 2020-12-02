USE Eduquaydb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchMobileAppLeftSideMenu' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchMobileAppLeftSideMenu 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchMobileAppLeftSideMenu] 
AS 
BEGIN 
	SELECT ID
		,MenuName
		,MenuLink
		
	FROM Tbl_MobileAppLeftSideMenu 
	WHERE Isactive = 1
END

