USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllBlocks]    Script Date: 03/25/2020 13:21:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[SPC_FetchAllBlocks]
As
Begin
	SELECT B.[ID]
		,D.[Districtname]
		,B.[DistrictID]
		,B.[Blockname]
		,B.[Block_gov_code]
		,B.[Isactive]
		,B.[Comments] 
		,B.[Createdby]
		,B.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_BlockMaster] B
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = B.DistrictID
	Order by B.[ID]
End
