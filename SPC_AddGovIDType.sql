USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_AddGovIDType' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddGovIDType
End
GO
CREATE procedure [dbo].[SPC_AddGovIDType]
(	
	@GovIDType varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@gtCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @GovIDType is not null
		Begin
			select @gtCount =  count(ID) from Tbl_Gov_IDTypeMaster where GovIDType = @GovIDType
			select @ID =  ID from Tbl_Gov_IDTypeMaster where GovIDType = GovIDType
			if(@gtCount <= 0)
			Begin
				insert into Tbl_Gov_IDTypeMaster (
					GovIDType
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@GovIDType
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_Gov_IDTypeMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_Gov_IDTypeMaster set 
				GovIDType = @GovIDType
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @ID
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
