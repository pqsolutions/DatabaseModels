USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddThresholdValue' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddThresholdValue
End
GO
CREATE procedure [dbo].[SPC_AddThresholdValue]
(	
	@TestTypeID int
	,@TestName varchar(150)
	,@ThresholdValue decimal(18,2)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
	,@Scope_output int output
) As
Declare
	@FCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @TestName is not null
		Begin
			select @FCount =  count(ID) from Tbl_ThresholdValueMaster where TestName = @TestName
			select @ID =  ID from Tbl_ThresholdValueMaster where TestName = @TestName
			if(@FCount <= 0)
			Begin
				insert into Tbl_ThresholdValueMaster (
					TestTypeID
					,TestName
					,Thresholdvalue
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@TestTypeID
				,@TestName
				,@ThresholdValue
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				set @tempUserId = IDENT_CURRENT('Tbl_ThresholdValueMaster')
				set @Scope_output = 1
			End
			else
			Begin
				Update Tbl_ThresholdValueMaster set
				TestTypeID = @TestTypeID
				,ThresholdValue = @ThresholdValue
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
