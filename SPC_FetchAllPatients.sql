USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllPatients]    Script Date: 03/20/2020 10:24:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllPatients' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllPatients
End
GO

CREATE Procedure [dbo].[SPC_FetchAllPatients]
As
Begin
	Select 
		[ID]
		,[GID]
		,[FIRSTNAME] 
		,[LASTNAME] 
		,[CITY] 
	From [dbo].[TBL_PATIENT] 
	Order by [GID]
End