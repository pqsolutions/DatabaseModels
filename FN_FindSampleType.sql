USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindSampleType' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_FindSampleType
END
GO
CREATE FUNCTION [dbo].[FN_FindSampleType]   
(
	@SubjectID INT	
) 
RETURNS @OutTable TABLE (SampleType CHAR(1), Reason VARCHAR(105))

--RETURNS CHAR(1)        
AS    
BEGIN
	DECLARE
		@SampleCount INT
		,@SampleType CHAR(1)
		,@Reason VARCHAR(100)
		,@Damaged BIT
		,@Timeout BIT
		SET @SampleType = 'F'
		SET @Reason = 'First Time Collection'
		IF EXISTS(SELECT 1 FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID)
		BEGIN
			SET @SampleType = 'R'
		END
		IF @SammpleType = 'R'
		BEGIN
			SELECT TOP 1 @Damaged = SampleDamaged, @Timeout = SampleTimeoutExpiry  FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID ORDER BY ID DESC
			IF @Damaged = 1 AND @Timeout = 1
			BEGIN
				SET @Reason = 'Damaged Sample'
			END
			ELSE IF @Damaged = 1 AND @Timeout = 0
			BEGIN
				SET @Reason = 'Damaged Sample'
			END
			ELSE IF @Damaged = 0 AND @Timeout = 1
			BEGIN
				SET @Reason = 'Sample Timeout'
			END
		END
		
		
		
	RETURN 	@SampleType
END