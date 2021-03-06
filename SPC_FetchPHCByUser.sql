USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPHCByUser]    Script Date: 03/26/2020 00:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPHCByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPHCByUser
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPHCByUser](@UserId INT)
 AS BEGIN  
 SELECT P.[ID] 
		,(P.[PHC_gov_code] + ' - ' +  P.[PHCname] )AS [PHCname]
		,P.[PHC_gov_code] 
 FROM [dbo]. [Tbl_UserMaster] U  
 LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON U.PHCID = P.ID  
 WHERE  U.[ID]  = @UserId AND P.[Isactive] = 1
END  