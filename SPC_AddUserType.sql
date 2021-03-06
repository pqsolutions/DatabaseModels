USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddUserType]    Script Date: 03/25/2020 23:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddUserType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddUserType
End
GO
CREATE procedure [dbo].[SPC_AddUserType] 
(	
	@UserType varchar(50)	
	,@Isactive  Bit	
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
) As
Declare
	@utCount int
	,@id int
	,@tempUserId int
Begin
	Begin try
		If @UserType != '' or @UserType is not null 
		Begin
			select @utCount =  count(ID) from Tbl_UserTypeMaster where UserType = @UserType
			select @id = ID from Tbl_UserTypeMaster where UserType = @UserType
			if(@utCount <= 0)
			Begin
				insert into Tbl_UserTypeMaster (
					Usertype					
					,Isactive					
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@UserType
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'User Type added successfully' AS Msg

			End
			else
			Begin
				Update Tbl_UserTypeMaster set 
				UserType = @UserType
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @id
				SELECT 'User Type updated successfully' AS Msg

			End
		End
		else
		Begin
			SELECT 'User Type is missing' AS Msg

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
