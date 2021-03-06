USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllSubjectType]    Script Date: 03/26/2020 00:05:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllSubjectType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllSubjectType
End
GO

Create Procedure [dbo].[SPC_FetchAllSubjectType]
As
Begin
	SELECT [ID]
		 ,[SubjectType]	
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_SubjectTypeMaster]
	Order by [ID]
End
