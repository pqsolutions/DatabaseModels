USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRI]    Script Date: 03/25/2020 17:30:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER Procedure [dbo].[SPC_FetchRI] (@ID int)
As Begin  
 SELECT R.[ID]  
  ,R.[PHCID]  
  ,P.[PHCname]  
  ,R.[SCID]
  ,S.[SCname] 
  ,R.[RI_gov_code] 
  ,R.[RIsite] 
  ,R.[Pincode]  
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [Eduquaydb].[dbo].[Tbl_RIMaster] R
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_SCMaster] S WITH (NOLOCK) ON S.ID = R.SCID  
 LEFT JOIN [Eduquaydb].[dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = R.PHCID    
 WHERE  R.[ID]  = @ID
End  