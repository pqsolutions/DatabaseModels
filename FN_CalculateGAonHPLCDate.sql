--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_CalculateGAonHPLCDate' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_CalculateGAonHPLCDate
END
GO
CREATE FUNCTION [dbo].[FN_CalculateGAonHPLCDate]   
(
	@ID INT
	,@Barcode VARCHAR(200)
) 
RETURNS VARCHAR(20)        
AS    
BEGIN
	DECLARE
		@LMPDate  DATETIME
		,@HPLCTestedDateTime DATETIME
		,@Week INT
		,@Day INT
		,@GestationalAge VARCHAR(20)		
		SET @LMPDate = (SELECT TOP 1 LMP_Date FROM Tbl_SubjectPregnancyDetail WHERE SubjectId = @ID)
		SET @HPLCTestedDateTime = (SELECT  TestedDateTime FROM Tbl_HPLCTestedDetail WHERE Barcode=@Barcode AND ProcessStatus = 1 AND SampleStatus = 1)
		IF @LMPDATE IS NOT NULL OR @LMPDATE != ''
		BEGIN
			SET @Week = (SELECT DATEDIFF(DAY, @LMPDate, @HPLCTestedDateTime)/7) 
			SET @Day = (SELECT DATEDIFF(DAY, @LMPDate, @HPLCTestedDateTime)%7)
			SET @GestationalAge = (CAST(@Week AS VARCHAR(5)) + '.' + CAST(@Day AS VARCHAR(5)))
		END
		ELSE
		BEGIN
			SET @GestationalAge = '0'
		END
	RETURN 	@GestationalAge
END