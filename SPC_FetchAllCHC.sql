USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllCHC]    Script Date: 03/25/2020 14:29:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchAllCHC]
As
Begin
	SELECT C.[ID]
		,D.[Districtname]
		,C.[DistrictID]
		,B.[Blockname]
		,C.[BlockID]
		,C.[CHC_gov_code]
		,C.[CHCname]
		,C.[Istestingfacility]
		,C.[HNIN_ID]
		,H.[NIN2HFI]
		,C.[Isactive]
		,C.[Comments] 
		,C.[Createdby]
		,C.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_CHCMaster] C
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = C.BlockID
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_HNINMaster] H WITH (NOLOCK) ON H.ID = C.HNIN_ID
	Order by C.[ID]
End
