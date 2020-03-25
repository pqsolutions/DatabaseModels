USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllPHC]    Script Date: 03/26/2020 00:02:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllPHC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllPHC
End
GO
CREATE Procedure [dbo].[SPC_FetchAllPHC] As Begin  
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
 Order by P.[ID]  
End  