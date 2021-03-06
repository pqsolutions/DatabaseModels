USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllHNIN]    Script Date: 03/26/2020 00:01:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllHNIN' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllHNIN
End
GO
CREATE Procedure [dbo].[SPC_FetchAllHNIN]
As
Begin
	SELECT H.[ID]
		,S.[Statename]
		,H.[StateID]
		,D.[Districtname]
		,H.[DistrictID]
		,B.[Blockname]
		,H.[BlockID]
		,H.[NIN2HFI]
		,H.[Facilitytype_ID]
		,F.[Facility_typename]		
		,H.[Facility_name]
		,H.[Taluka]
		,H.[Address]
		,H.[Pincode]
		,H.[Landline]
		,H.[Incharge_name]
		,H.[Incharge_contactno]
		,H.[Incharge_EmailId]
		,H.[Latitude]
		,H.[Longitude]	
		,H.[Isactive]
		,H.[Comments] 
		,H.[Createdby]
		,H.[Updatedby]      
	FROM [dbo].[Tbl_HNINMaster] H
	LEFT JOIN [dbo].[Tbl_FacilityTypeMaster] F WITH (NOLOCK) ON F.ID = H.Facilitytype_ID
	LEFT JOIN [dbo].[Tbl_BlockMaster] B WITH (NOLOCK) ON B.ID = H.BlockID
	LEFT JOIN [dbo].[Tbl_DistrictMaster] D WITH (NOLOCK) ON D.ID = H.DistrictID
	LEFT JOIN [dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = H.StateID
	Order by H.[ID]
End
