--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRIBySC]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchRIBySC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchRIBySC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchRIBySC] (@Id INT)
AS BEGIN
 SELECT R.[ID]
		,R.[RI_gov_code]
		,R.[RIsite]
		,C.[CHCname]
		,R.[CHCID]
		,C.[BlockID]
		,B.[Blockname]
		,C.[DistrictID]
		,D.[Districtname]
		,R.[PHCID]
		,P.[PHCname]
		,R.[Isactive]
		,R.[Comments] 
		,R.[Createdby] 
		,R.[Updatedby]  
		,R.[TestingCHCID]
		,CH.[CHCname] AS TestingCHCName
		,R.[SCID]
		,S.[SCname]
		,R.[ILRID]
		,I.[ILRPoint]
		,R.[Pincode]
		,R.[Latitude]
		,R.[Longitude]
	FROM [dbo].[Tbl_RIMaster] R
	LEFT JOIN [dbo].[Tbl_SCMaster] S WITH (NOLOCK) ON S.ID = R.SCID
	LEFT JOIN [dbo].[Tbl_PHCMaster] P WITH (NOLOCK) ON P.ID = R.PHCID
	LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = R.CHCID
	LEFT JOIN [dbo].[Tbl_CHCMaster] CH WITH (NOLOCK) ON CH.ID = R.TestingCHCID
	LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = C.BlockID	
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = B.DistrictID	
	LEFT JOIN [dbo].[Tbl_ILRMaster] I WITH (NOLOCK) ON I.ID = R.ILRID	
	WHERE R.[SCID] = @Id AND R.[Isactive] = 1
END  