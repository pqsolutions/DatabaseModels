USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllFacilityType]    Script Date: 03/25/2020 13:39:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[SPC_FetchAllFacilityType]
As
Begin
	SELECT [ID]
		 ,[Facility_typename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [Eduquaydb].[dbo].[Tbl_FacilityTypeMaster]
	Order by [ID]
End
