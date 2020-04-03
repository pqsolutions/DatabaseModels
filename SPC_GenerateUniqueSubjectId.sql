USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (Select 1 from sys.objects where name='SPC_GenerateUniqueSubjectId' and [type] = 'p')
Begin
	Drop Procedure SPC_GenerateUniqueSubjectId
End
GO
Create Procedure [dbo].[SPC_GenerateUniqueSubjectId] 
(
	@ANMID int
	,@Source char(1)	
) As
Declare	
	@UniqueSubjectId varchar(MAX)	
Begin
	Begin try
	
		Set @UniqueSubjectId = (Select [dbo].[FN_GenerateUniqueSubjectId](@ANMID,@Source))
		Select @UniqueSubjectId As UniqueSubjectId
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

