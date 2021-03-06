USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchSC]    Script Date: 03/26/2020 00:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchSC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchSC
END
GO
CREATE  PROCEDURE [dbo].[SPC_FetchSC] (@ID INT)
AS BEGIN  
 SELECT S.[ID]  
  ,S.[CHCID]  
  ,C.[CHCname]  
  ,S.[PHCID]
  ,P.[PHCname] 
  ,S.[SC_gov_code]  
  ,S.[SCname] 
  ,S.[SCAddress]
  ,S.[Pincode]   
  ,S.[HNIN_ID] 
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [dbo].[Tbl_SCMaster] S  
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = S.CHCID 
 LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = S.PHCID 
 WHERE S.[ID] = @ID 
END  