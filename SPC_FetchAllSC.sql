USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllSC]    Script Date: 03/25/2020 17:12:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER Procedure [dbo].[SPC_FetchAllSC] 
As Begin  
 SELECT S.[ID]  
  ,S.[CHCID]  
  ,C.[CHCname]  
  ,S.[PHCID]
  ,P.[PHCname] 
  ,S.[SC_gov_code]  
  ,S.[Pincode]   
  ,S.[HNIN_ID]
  ,H.[NIN2HFI]   
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [Eduquaydb].[dbo].[Tbl_SCMaster] S  
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = S.CHCID 
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = S.PHCID 
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_HNINMaster] H WITH (NOLOCK) ON H.ID = S.HNIN_ID  
 Order by S.[ID]  
End  