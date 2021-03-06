USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllBlocks]    Script Date: 03/25/2020 23:58:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllBlocks' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllBlocks
End
GO
CREATE Procedure [dbo].[SPC_FetchAllBlocks]
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
	FROM [dbo].[Tbl_BlockMaster] B
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = B.DistrictID
	Order by B.[ID]
End
