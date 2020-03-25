USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllDistricts]    Script Date: 03/26/2020 00:00:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllDistricts' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllDistricts
End
GO
CREATE Procedure [dbo].[SPC_FetchAllDistricts]
As
Begin
	SELECT D.[ID]
		,S.[Statename]
		,D.[StateID]
		,D.[Districtname]
		,D.[District_gov_code]
		,D.[Isactive]
		,D.[Comments] 
		,D.[Createdby]
		,D.[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [Eduquaydb].[dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = D.StateID
	Order by D.[ID]
End
