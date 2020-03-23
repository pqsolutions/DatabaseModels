USE [Eduquaydb]
GO

/****** Object:  StoredProcedure [dbo].[SPC_FindUserByEmail]    Script Date: 3/22/2020 7:46:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[SPC_FindUserByEmail] (@USEREMAIL varchar(200))
As
Begin
	Select * 
	From [TBL_TUSER] where Useremail = @USEREMAIL
End
GO


