
--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdatePrePNDTCounsellingByAutomatic' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdatePrePNDTCounsellingByAutomatic 
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdatePrePNDTCounsellingByAutomatic] 

AS
DECLARE
	@CurrentCounsellingId INT
	,@Indexvar INT
	,@TotalCount INT
	
BEGIN
	BEGIN TRY
	
		CREATE  TABLE #TempTable(code int identity(1,1), counsellingId int)
				
		INSERT INTO #TempTable(counsellingId) (SELECT ID FROM Tbl_PrePNDTCounselling 
		WHERE [IsActive] = 1 AND [ID] NOT IN(SELECT PrePNDTCounsellingId FROM Tbl_PNDTestNew)
		AND (SELECT [dbo].[FN_CalculateGestationalAgeBySubId]([ANWSubjectId])) > 30)
		
		SELECT @TotalCount = COUNT(code) FROM #TempTable
		SET @IndexVar = 0 
		WHILE @Indexvar < @TotalCount  
		BEGIN
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentCounsellingId = counsellingId FROM  #TempTable WHERE code = @Indexvar
			
			UPDATE Tbl_PrePNDTCounselling SET 
				IsActive = 0 
				,ReasonForClose = 'Not Valid For PNDT, Because the GA is crossed 30 weeks'
			WHERE ID = @CurrentCounsellingId
			
		END
		
		DROP TABLE #TempTable
	
	
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