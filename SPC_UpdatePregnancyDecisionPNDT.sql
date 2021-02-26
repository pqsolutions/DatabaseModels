--USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_UpdatePregnancyDecisionPNDT' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_UpdatePregnancyDecisionPNDT
END
GO
CREATE PROCEDURE [dbo].[SPC_UpdatePregnancyDecisionPNDT]
(	
	@PNDTestId INT
	,@PNDTFoetusId INT
	,@PlanForPregnencyContinue BIT
	,@UserId INT
)
AS
DECLARE @CVSSampleId VARCHAR(200)
BEGIN
	BEGIN TRY
		UPDATE Tbl_PNDTFoetusDetail SET 
			PlanForPregnencyContinue = @PlanForPregnencyContinue
			,UpdatedBy = @UserId
			,UpdatedOn = GETDATE()
			,IsReviewed = 1
			,ReviewedBy = @UserId
			,ReviewedOn = GETDATE()
		WHERE ID = @PNDTFoetusId

		UPDATE Tbl_PNDTestNew SET 
			IsCompletePNDT = 1
			,UpdatedBy = @UserId
			,UpdatedOn = GETDATE()
		WHERE ID = @PNDTestId

		SELECT CVSSampleRefId FROM Tbl_PNDTFoetusDetail WHERE ID = @PNDTFoetusId
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
