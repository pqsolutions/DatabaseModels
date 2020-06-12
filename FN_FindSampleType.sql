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
RETURNS CHAR(1)        
AS    
BEGIN
	DECLARE
		@SampleCount INT
		,@SampleType CHAR(1)		
		SET @SampleCount = (SELECT  COUNT(*) FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID)
		IF @SampleCount = 0
		BEGIN
			SET @SampleType = 'F'
		END
		ELSE
		BEGIN
			SET @SampleType = 'R'
		END
	RETURN 	@SampleType
END