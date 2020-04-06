USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllReligion' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllReligion
End
GO
CREATE Procedure [dbo].[SPC_FetchAllReligion]
As
Begin
	SELECT [ID]
		 ,[Religionname]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_ReligionMaster]
	Order by [ID]
End
