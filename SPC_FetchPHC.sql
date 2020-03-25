USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPHC]    Script Date: 03/25/2020 15:54:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER Procedure [dbo].[SPC_FetchPHC](@ID int)
 As Begin  
 SELECT P.[ID]  
  ,P.[CHCID]  
  ,C.[CHCname]  
  ,P.[PHC_gov_code]  
  ,P.[PHCname]   
  ,P.[HNIN_ID] 
  ,H.[NIN2HFI]  
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [Eduquaydb].[dbo].[Tbl_PHCMaster] P  
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = P.CHCID  
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_HNINMaster] H WITH (NOLOCK) ON H.ID = P.HNIN_ID
 WHERE  P.[ID]  = @ID
End  