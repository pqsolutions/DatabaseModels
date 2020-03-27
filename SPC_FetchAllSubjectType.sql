USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	FROM [Eduquaydb].[dbo].[Tbl_SubjectTypeMaster]
	Order by [ID]
End
