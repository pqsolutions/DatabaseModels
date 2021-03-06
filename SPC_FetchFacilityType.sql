USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchFacilityType]    Script Date: 03/26/2020 00:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchFacilityType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchFacilityType
End
GO
CREATE Procedure [dbo].[SPC_FetchFacilityType] (@ID int)
as
Begin
	SELECT [ID]
		 ,[Facility_typename]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_FacilityTypeMaster] where ID = @ID		
End

