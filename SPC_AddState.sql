USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddState]    Script Date: 03/25/2020 23:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_AddState' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddState
End
GO
CREATE procedure [dbo].[SPC_AddState] 
(	
	@State_gov_code varchar(50)
	,@Statename varchar(100)
	,@Shortname varchar(10)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@stateCount int
	,@tempUserId int
Begin
	Begin try
		If @State_gov_code != '' or @State_gov_code is not null 
		Begin
			select @stateCount =  count(ID) from Tbl_StateMaster where State_gov_code= @State_gov_code
			if(@stateCount <= 0)
			Begin
				insert into Tbl_StateMaster (
					State_gov_code
					,Statename
					,Shortname
					,Isactive
					,Latitude
					,Longitude
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@State_gov_code
				,@Statename
				,@Shortname
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_StateMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_StateMaster set 
				State_gov_code = @State_gov_code
				,Statename = @Statename
				,Shortname=@Shortname
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where State_gov_code = @State_gov_code
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
