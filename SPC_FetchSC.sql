USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchSC]    Script Date: 03/26/2020 00:13:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchSC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchSC
End
GO
CREATE  Procedure [dbo].[SPC_FetchSC] (@ID int)
As Begin  
 SELECT S.[ID]  
  ,S.[CHCID]  
  ,C.[CHCname]  
  ,S.[PHCID]
  ,P.[PHCname] 
  ,S.[SC_gov_code]  
  ,S.[SCname] 
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
End  