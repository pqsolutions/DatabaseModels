--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_AddBlock]    Script Date: 03/25/2020 22:38:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddBlock' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddBlock
End
GO

CREATE procedure [dbo].[SPC_AddBlock]
(	
	@Block_gov_code varchar(50)
	,@DistrictID int
	,@Blockname varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
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
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Block added successfully' AS Msg
			End
			else
			Begin
				Update Tbl_BlockMaster set 
				Block_gov_code = @Block_gov_code
				,DistrictID=@DistrictID
				,Blockname = @Blockname
				,Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @id
				SELECT 'Block updated successfully' AS Msg
			End
		End
		else
		Begin
			SELECT 'Block code is missing' AS Msg
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
