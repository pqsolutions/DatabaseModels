USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllCHC]    Script Date: 03/20/2020 18:36:46 ******/
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
		,H.[Facility_name]
		,C.[Isactive]
		,C.[Comments] 
		,C.[Createdby]
		,C.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Masters_CHC] C
	LEFT JOIN [Eduquaydb].[dbo].[Masters_Block] B WITH (NOLOCK) ON B.ID = C.BlockID
	LEFT JOIN [Eduquaydb].[dbo].[Masters_District] D WITH (NOLOCK) ON D.ID = C.DistrictID
	LEFT JOIN [Eduquaydb].[dbo].[Masters_HNIN] H WITH (NOLOCK) ON H.ID = C.HNIN_ID
	Order by C.[ID]
End
