USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMbyPHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMbyPHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchANMbyPHC](@Id INT)
 AS BEGIN  
 SELECT U.[ID] AS Id
		,(U.[FirstName] + ' ' + U.[LastName] )  AS Name
 FROM [dbo].[Tbl_UserMaster] U
 LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON U.PHCID = P.ID  
 WHERE  U.[PHCID]  = @Id AND U.[UserType_ID] = (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
END  