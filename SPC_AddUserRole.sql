USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddUserRole] 
(	
	@UserTypeID int
	,@Userrolename varchar(150)
	,@Isactive  Bit	
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@urCount int
	,@id int
	,@tempUserId int
Begin
	Begin try
		If @Userrolename != '' or @Userrolename is not null 
		Begin
			select @urCount =  count(ID) from Tbl_UserRoleMaster where UsertypeID = @UserTypeID and Userrolename = @Userrolename
			select @id = ID from Tbl_UserRoleMaster where UsertypeId = @UserTypeID and Userrolename = @Userrolename
			if(@urCount <= 0)
			Begin
				insert into Tbl_UserRoleMaster (
					UsertypeID
					,Userrolename					
					,Isactive					
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@UserTypeID
				,@Userrolename
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_UserRoleMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_UserRoleMaster set 
				UserTypeID = @UserTypeID
				,Userrolename = @Userrolename
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @id
			End
		End
		else
		Begin
			set @Scope_output = -1
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
