USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchBlock]    Script Date: 03/26/2020 00:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




IF EXISTS (Select 1 from sys.objects where name='SPC_FetchBlock' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchBlock
End
GO
CREATE Procedure [dbo].[SPC_FetchBlock] (@ID int)
as
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
	where B.ID = @ID		
End

