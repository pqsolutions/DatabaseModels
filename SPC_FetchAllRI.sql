USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllRI]    Script Date: 03/26/2020 00:03:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllRI' AND [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllRI
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllRI] 
AS BEGIN  
 SELECT R.[ID]  
  ,R.[TestingCHCID]
  ,C.[CHCname] AS TestingCHC
  ,R.[CHCID]
  ,TC.[CHCname] CHCName
  ,R.[PHCID]  
  ,P.[PHCname]  
  ,R.[SCID]
  ,S.[SCname] 
  ,R.[RI_gov_code] 
  ,R.[RIsite] 
  ,R.[Pincode]
  ,R.[ILRID]
  ,I.[ILRPoint]  
  ,P.[Isactive]  
  ,P.[Comments]   
  ,P.[Createdby]  
  ,P.[Updatedby]        
 FROM [dbo].[Tbl_RIMaster] R
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = R.TestingCHCID 
 LEFT JOIN [dbo].[Tbl_CHCMaster] TC WITH (NOLOCK) ON TC.ID = R.CHCID  
 LEFT JOIN [dbo].[Tbl_SCMaster] S WITH (NOLOCK) ON S.ID = R.SCID  
 LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = R.PHCID 
 LEFT JOIN [dbo].[Tbl_ILRMaster] I WITH (NOLOCK) ON I.ID = R.ILRID 
 ORDER BY R.[ID]  
END  