

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddPrePNDTScheduling' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddPrePNDTScheduling 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddPrePNDTScheduling] 
(
	@ANWSubjectId VARCHAR(250)
	,@SpouseSubjectId VARCHAR(250)
	,@CounsellorId INT
	,@CounsellingDateTime VARCHAR(100)
	,@CreatedBy INT
)
AS
DECLARE 
	@GetId INT
BEGIN

	BEGIN TRY
		IF NOT EXISTS(SELECT 1 FROM Tbl_PrePNDTScheduling WHERE ANWSubjectId = @ANWSubjectId)
		BEGIN
			INSERT INTO Tbl_PrePNDTScheduling (
				ANWSubjectId 
				,SpouseSubjectId 
				,CounsellorId 
				,CounsellingDateTime 
				,IsCounselled 
				,CreatedBy 
				,CreatedOn
			)VALUES(
				@ANWSubjectId 
				,@SpouseSubjectId 
				,@CounsellorId 
				,@CounsellingDateTime 
				,0 
				,@CreatedBy 
				,GETDATE())
			
			SET @GetId = (SELECT SCOPE_IDENTITY())
			SELECT CONVERT(VARCHAR,CounsellingDateTime,103) AS CounsellingDate 
				,(CONVERT(VARCHAR(5),CONVERT(TIME(2),CounsellingDateTime,103))) AS CounsellingTime
			FROM Tbl_PrePNDTScheduling 
			WHERE ID = @GetId 
		END
		ELSE
		BEGIN
			UPDATE  Tbl_PrePNDTScheduling SET
				CounsellorId = @CounsellorId 
				,CounsellingDateTime = @CounsellingDateTime
				,UpdatedBy = @CreatedBy 
				,UpdatedOn = GETDATE()
			WHERE ANWSubjectId = @ANWSubjectId
			
			SELECT CONVERT(VARCHAR,CounsellingDateTime,103) AS CounsellingDate 
				,(CONVERT(VARCHAR(5),CONVERT(TIME(2),CounsellingDateTime,103))) AS CounsellingTime
			FROM Tbl_PrePNDTScheduling 
			WHERE ANWSubjectId = @ANWSubjectId
		END
	END TRY
	BEGIN CATCH
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
	END CATCH
END