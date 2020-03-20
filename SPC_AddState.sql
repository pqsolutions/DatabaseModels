USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddState]    Script Date: 03/20/2020 10:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddState]
(	
	@State_gov_code int
	,@Statename varchar(100)
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
		If @State_gov_code is not null or @State_gov_code > 0
		Begin
			select @stateCount =  count(ID) from Masters_State where State_gov_code= @State_gov_code
			if(@stateCount <= 0)
			Begin
				insert into Masters_State (
					State_gov_code
					,Statename
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
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Masters_State')
				set @Scope_output = 1
			End
			else
			Begin
				Update Masters_State set 
				State_gov_code=@State_gov_code
				,Statename = @Statename
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments=@Comments
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
