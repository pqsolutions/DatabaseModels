USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchPHC]    Script Date: 03/26/2020 00:11:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchPHC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchPHC
End
GO
CREATE Procedure [dbo].[SPC_FetchPHC](@ID int)
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
 FROM [dbo].[Tbl_PHCMaster] P  
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = P.CHCID  
 LEFT JOIN [dbo].[Tbl_HNINMaster] H WITH (NOLOCK) ON H.ID = P.HNIN_ID
 WHERE  P.[ID]  = @ID
End  