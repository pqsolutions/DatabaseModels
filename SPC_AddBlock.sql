USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddBlock]    Script Date: 03/20/2020 18:34:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[SPC_AddBlock]
(	
	@Block_gov_code varchar(50)
	,@DistrictID int
	,@Blockname varchar(100)
	,@Isactive  Bit
	,@Latitude varchar(150)
	,@Longitude varchar(150)
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@blockCount int
	,@tempUserId int
Begin
	Begin try
		If @Block_gov_code is not null or @Block_gov_code > 0
		Begin
			select @blockCount =  count(ID) from Masters_Block where Block_gov_code= @Block_gov_code
			if(@blockCount <= 0)
			Begin
				insert into Masters_Block (
					Block_gov_code
					,DistrictID
					,Blockname
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
				@Block_gov_code
				,@DistrictID
				,@Blockname
				,@Isactive
				,@Latitude
				,@Longitude
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Masters_Block')
				set @Scope_output = 1
			End
			else
			Begin
				Update Masters_Block set 
				Block_gov_code = @Block_gov_code
				,DistrictID=@DistrictID
				,Blockname = @Blockname
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where Block_gov_code = @Block_gov_code
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
