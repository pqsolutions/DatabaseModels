USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchCHC]    Script Date: 03/26/2020 00:08:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchCHC] (@ID INT)
AS
BEGIN
	SELECT C.[ID]
		,D.[Districtname]
		,C.[DistrictID]
		,B.[Blockname]
		,C.[BlockID]
		,C.[CHC_gov_code]
		,C.[CHCname]
		,C.[Istestingfacility]
		,C.[TestingCHCID]
		,CM.[CHCname] AS TestingCHC
		,C.[CentralLabId]
		,CL.[CentralLabName] 
		,C.[HNIN_ID]
		,C.[Pincode]
		,C.[Isactive]
		,C.[Comments] 
		,C.[Createdby]
		,C.[Updatedby]      
	FROM [dbo].[Tbl_CHCMaster] C
	LEFT JOIN [dbo].[Tbl_CHCMaster] CM WITH (NOLOCK) ON CM.TestingCHCID = C.ID
	LEFT JOIN [Tbl_CentralLabMaster] CL WITH (NOLOCK) ON CL.ID = C.CentralLabId
	LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = C.BlockID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = C.DistrictID	
	WHERE C.ID = @ID		
END

