USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllRI]    Script Date: 03/26/2020 00:03:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllRI' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllRI
End
GO
CREATE Procedure [dbo].[SPC_FetchAllRI] 
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
 Order by R.[ID]  
End  