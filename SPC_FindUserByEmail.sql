USE [Eduquaydb]
GO

/****** Object:  StoredProcedure [dbo].[SPC_FindUserByEmail]    Script Date: 3/22/2020 7:46:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_FindUserByEmail' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FindUserByEmail
End
GO


CREATE Procedure [dbo].[SPC_FindUserByEmail] (@USEREMAIL varchar(200))
As
Begin
	Select * 
	From [TBL_TUSER] where Useremail = @USEREMAIL
End
GO


