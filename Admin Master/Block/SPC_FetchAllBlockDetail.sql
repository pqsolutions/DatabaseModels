--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllBlockDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllBlockDetail
END
GO
CREATE Procedure [dbo].[SPC_FetchAllBlockDetail] 
AS
BEGIN
	SELECT B.[ID]
		,B.[Blockname]
		,B.[Block_gov_code]
		,B.[DistrictID]
		,D.[Districtname]
		,B.[Isactive]
		,B.[Comments] 
		,B.[Createdby] 
		,B.[Updatedby]     
	FROM [dbo].[Tbl_BlockMaster] B
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = B.DistrictID	
			
END

