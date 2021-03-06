USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPHC]    Script Date: 03/26/2020 00:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchPHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchPHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchPHC](@ID INT)
 AS BEGIN  
 SELECT P.[ID]  
  ,P.[CHCID]  
  ,C.[CHCname]  
  ,P.[PHC_gov_code]  
  ,P.[PHCname]   
  ,P.[HNIN_ID] 
  ,P.[Pincode]
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [dbo].[Tbl_PHCMaster] P  
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = P.CHCID  
 WHERE  P.[ID]  = @ID
END  