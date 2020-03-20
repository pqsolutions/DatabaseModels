USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllBlocks]    Script Date: 03/20/2020 18:36:23 ******/
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
	FROM [Eduquaydb].[dbo].[Masters_Block] B
	LEFT JOIN [Eduquaydb].[dbo].[Masters_District] D WITH (NOLOCK) ON D.ID = B.DistrictID
	Order by B.[ID]
End
