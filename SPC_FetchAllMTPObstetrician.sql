USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllMTPObstetrician' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllMTPObstetrician 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllMTPObstetrician] 

AS
BEGIN
	SELECT U.[Id] AS Id
		,(U.[FirstName]+' '+U.[LastName]) AS Name
	FROM Tbl_UserMaster U
	WHERE U.UserRole_ID IN (SELECT ID FROM Tbl_UserRoleMaster WHERE Userrolename = 'MTPOBSTETRICIAN')
END