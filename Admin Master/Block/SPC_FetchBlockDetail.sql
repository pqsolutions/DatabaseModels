--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchBlockDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchBlockDetail
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchBlockDetail] (@ID INT)
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
	WHERE B.ID = @ID		
END

