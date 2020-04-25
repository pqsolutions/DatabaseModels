USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllTestType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllTestType
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllTestType]
As
BEGIN
	SELECT [ID]
		 ,[TestType]
		 ,[Isactive]
		 ,[Comments] 
		 ,[Createdby] 
		 ,[Updatedby]      
	FROM [dbo].[Tbl_TestTypeMaster]		
END

