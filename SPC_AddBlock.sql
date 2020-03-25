USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddBlock]    Script Date: 03/25/2020 13:17:44 ******/
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
	,@id int
	,@tempUserId int
Begin
	Begin try
		If @Block_gov_code != '' or @Block_gov_code is not null 
		Begin
			select @blockCount =  count(ID) from Tbl_BlockMaster where Block_gov_code= @Block_gov_code
			Select @id = ID from   Tbl_BlockMaster where Block_gov_code= @Block_gov_code
			if(@blockCount <= 0)
			Begin
				insert into Tbl_BlockMaster (
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
				set @tempUserId = IDENT_CURRENT('Tbl_BlockMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_BlockMaster set 
				Block_gov_code = @Block_gov_code
				,DistrictID=@DistrictID
				,Blockname = @Blockname
				,Isactive = @Isactive
				,Latitude = @Latitude
				,Longitude = @Longitude
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
