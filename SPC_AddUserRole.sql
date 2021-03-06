USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddUserRole]    Script Date: 03/25/2020 23:57:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddUserRole' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddUserRole
End
GO
CREATE procedure [dbo].[SPC_AddUserRole] 
(	
	@UserTypeID int
	,@Userrolename varchar(150)
	,@Isactive  Bit	
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
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
				SELECT 'User role added successfully' AS Msg
				
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
				SELECT 'User role updated  successfully' AS Msg

			End
		End
		else
		Begin
			SELECT 'User role is missing' AS Msg

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
