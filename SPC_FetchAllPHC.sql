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
  ,P.[Pincode]
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [dbo].[Tbl_PHCMaster] P  
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = P.CHCID
 Order by P.[ID]  
End  