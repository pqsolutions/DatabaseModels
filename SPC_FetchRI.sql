USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRI]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchRI' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchRI
End
GO
CREATE Procedure [dbo].[SPC_FetchRI] (@ID int)
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