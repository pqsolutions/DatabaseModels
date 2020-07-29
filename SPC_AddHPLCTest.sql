

USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_AddHPLCTest' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_AddHPLCTest 
END
GO
CREATE PROCEDURE [dbo].[SPC_AddHPLCTest] 
(
	@UniqueSubjectId VARCHAR(250)
	,@BarcodeNo VARCHAR(250)
	,@CentralLabId INT
	,@HbF DECIMAL(10,3)
	,@HbA0 DECIMAL(10,3)
	,@HbA2 DECIMAL(10,3)
	,@HbS DECIMAL(10,3)
	,@HbC DECIMAL(10,3)
	,@HbD DECIMAL(10,3)
	,@CreatedBy INT
)
AS
DECLARE 
	@IsNormal BIT
	
BEGIN
	BEGIN TRY
		SET @IsNormal = 1
		IF(@HbF > 5 OR @HbA2 > 3.4 OR  @HbA0 > 0 OR @HbS > 0 OR @HbC > 0 OR  @HbD > 0)
		BEGIN
			SET @IsNormal = 0
		END
		
		INSERT INTO Tbl_HPLCTestResult(
			[UniqueSubjectID]
           ,[BarcodeNo]
           ,[CentralLabId]
           ,[HbF]
           ,[HbA0]
           ,[HbA2]
           ,[HbS]
           ,[HbC]
           ,[HbD]
           ,[IsNormal]
           ,[HPLCTestComplete]
           ,[HPLCTestCompletedOn]
           ,[CreatedOn]
           ,[CreatedBy])
		VALUES(
			@UniqueSubjectID
           ,@BarcodeNo
           ,@CentralLabId
           ,@HbF
           ,@HbA0
           ,@HbA2
           ,@HbS
           ,@HbC
           ,@HbD
           ,@IsNormal
           ,1
           ,GETDATE()
           ,GETDATE()
           ,@CreatedBy)
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