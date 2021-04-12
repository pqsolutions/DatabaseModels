--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE NAME='SPC_FetchUserRoleByUserType' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchUserRoleByUserType 
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchUserRoleByUserType](@UserTypeId INT)
AS
BEGIN
	SELECT [ID]
		 ,Descriptions AS NAME
		 
	FROM [dbo].[Tbl_UserRoleMaster]  WHERE  [IsActive] = 1 AND UsertypeID = @UserTypeId
	ORDER BY  [Descriptions] 
END
