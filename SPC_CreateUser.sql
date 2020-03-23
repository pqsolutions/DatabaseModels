USE [Eduquaydb]
GO

/****** Object:  StoredProcedure [dbo].[SPC_CreateUser]    Script Date: 3/22/2020 7:45:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[SPC_CreateUser] 
(
	@USEREMAIL varchar(200)
	,@PASSWORD varchar(250)
	,@FIRSTNAME varchar (100)
	,@LASTNAME varchar (100)
	,@SCOPE_OUTPUT int output
)
As
Declare
	@userCount int
	,@tempUserId int
Begin
	Begin try
		If @USEREMAIL is not null or @USEREMAIL != ''
		Begin
			select @userCount =  count(*) from [TBL_TUSER] where useremail = @USEREMAIL
			if(@userCount <= 0)
			Begin
				insert into [TBL_TUSER] (
					Useremail
					,Userpassword
					,UserFirstName
					,UserLastName
				) 
				values(
				@USEREMAIL
				,@PASSWORD
				,@FIRSTNAME
				,@LASTNAME
				)
				set @tempUserId = IDENT_CURRENT('TBL_TUSER')
				set @SCOPE_OUTPUT = 1
			End
			else
			Begin
				Update [TBL_TUSER] set 
				UserFirstName = @FIRSTNAME
				,UserLastName = @LASTNAME
				where Useremail = @USEREMAIL
			End
		End
		else
		Begin
			set @SCOPE_OUTPUT = -1
		End
	End try
	Begin catch
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

			DECLARE @ErrorNumber INT = ERROR_NUMBER();
			DECLARE @ErrorLine INT = ERROR_LINE();
			DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
			DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
			DECLARE @ErrorState INT = ERROR_STATE();

			PRINT 'Actual error number: ' + CAST(@ErrorNumber AS VARCHAR(10));
			PRINT 'Actual line number: ' + CAST(@ErrorLine AS VARCHAR(10));

			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);		
	End catch
End
GO


