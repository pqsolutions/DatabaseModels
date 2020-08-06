USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllHPLCResult' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllHPLCResult
End
GO
CREATE Procedure [dbo].[SPC_FetchAllHPLCResult] 
as
Begin
	SELECT [ID]
		 ,[HPLCResultName]	
		 ,[Isactive]
		 ,[Createdby] 
	FROM [dbo].[Tbl_HPLCResultMaster] 	
End

