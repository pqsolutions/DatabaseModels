--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllCHCDetail' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllCHCDetail
END
GO
CREATE Procedure [dbo].[SPC_FetchAllCHCDetail] 
AS
BEGIN
	SELECT C.[ID]
		,C.[CHCname]
		,C.[CHC_gov_code]
		,C.[BlockID]
		,B.[Blockname]
		,C.[DistrictID]
		,D.[Districtname]
		,C.[Istestingfacility]
		,C.[Isactive]
		,C.[Comments] 
		,C.[Createdby] 
		,C.[Updatedby]  
		,C.[TestingCHCID]
		,CH.[CHCname] AS TestingCHCName
		,C.[CentralLabId]
		,CL.[CentralLabName]
		,C.[HNIN_ID]
		,C.[Pincode]
		,C.[Isactive]
	FROM [dbo].[Tbl_CHCMaster] C
	LEFT JOIN [dbo].[Tbl_CHCMaster] CH WITH (NOLOCK) ON CH.ID = C.TestingCHCID
	LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = C.BlockID	
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = B.DistrictID	
	LEFT JOIN [dbo].[Tbl_CentralLabMaster] CL WITH (NOLOCK) ON CL.ID = C.CentralLabId	
END

