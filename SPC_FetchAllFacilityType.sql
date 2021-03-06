USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllFacilityType]    Script Date: 03/26/2020 00:01:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllFacilityType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllFacilityType
End
GO
CREATE Procedure [dbo].[SPC_FetchAllFacilityType]
As
Begin
	SELECT [ID]
		 ,[Facility_typename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_FacilityTypeMaster]
	Order by [ID]
End
