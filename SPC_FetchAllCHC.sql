USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllCHC]    Script Date: 03/25/2020 23:59:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllCHC' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllCHC
End
GO
CREATE Procedure [dbo].[SPC_FetchAllCHC]
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
		,C.[Pincode]		
		,C.[Isactive]
		,C.[Comments] 
		,C.[Createdby]
		,C.[Updatedby]      
	FROM [dbo].[Tbl_CHCMaster] C
	LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = C.BlockID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID
	Order by C.[ID]
End
