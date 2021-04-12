--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME='SPC_FetchUserTypes' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUserTypes
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUserTypes]
AS
BEGIN
	SELECT [ID]
		 ,[Usertype] AS NAME	
	FROM [dbo].[Tbl_UserTypeMaster]  WHERE  [IsActive] = 1
	ORDER BY  [Usertype] 
END
