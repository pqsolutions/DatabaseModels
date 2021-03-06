--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (Select 1 from sys.objects where name='SPC_AddClinicalDiagnosis' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_AddClinicalDiagnosis
End
GO
CREATE procedure [dbo].[SPC_AddClinicalDiagnosis]
(	
	@DiagnosisName varchar(100)
	,@Isactive  Bit
	,@Comments varchar(150)
	,@Createdby int
	,@Updatedby int
) As
Declare
	@FCount int
	,@ID int
	,@tempUserId int
Begin
	Begin try
		If @DiagnosisName is not null
		Begin
			select @FCount =  count(ID) from Tbl_ClinicalDiagnosisMaster where DiagnosisName = @DiagnosisName
			select @ID =  ID from Tbl_ClinicalDiagnosisMaster where DiagnosisName = @DiagnosisName
			if(@FCount <= 0)
			Begin
				insert into Tbl_ClinicalDiagnosisMaster (
					DiagnosisName
					,Isactive
					,Comments
					,Createdby
					,Updatedby
					,Createdon
					,Updatedon
				) 
				values(
				@DiagnosisName
				,@Isactive
				,@Comments
				,@Createdby
				,@Updatedby
				,GETDATE()
				,GETDATE()
				)
				SELECT 'Clinical diagnosis added successfully' AS Msg
			End
			else
			Begin
				Update Tbl_ClinicalDiagnosisMaster set 
				Isactive = @Isactive
				,Comments = @Comments
				,Updatedby = @Updatedby
				,Updatedon = GETDATE()
				where ID = @ID
				SELECT 'Clinical diagnosis updated successfully' AS Msg
			End
		End
		else
		Begin
			SELECT 'Diagnosis is missing' AS Msg
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
