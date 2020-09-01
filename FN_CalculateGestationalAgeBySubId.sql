USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_CalculateGestationalAgeBySubId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_CalculateGestationalAgeBySubId
END
GO
CREATE FUNCTION [dbo].[FN_CalculateGestationalAgeBySubId]   
(
	@SubId VARCHAR(250)	
) 
RETURNS DECIMAL(10,1)        
AS    
BEGIN
	DECLARE
		@LMPDate  DATETIME
		,@Week INT
		,@Day INT
		,@GestationalAge VARCHAR(20)		
		SET @LMPDate = (SELECT TOP 1 LMP_Date FROM Tbl_SubjectPregnancyDetail WHERE UniqueSubjectID = @SubId)
		IF @LMPDATE IS NOT NULL OR @LMPDATE != ''
		BEGIN
			SET @Week = (SELECT DATEDIFF(day, @LMPDate, GETDATE())/7) 
			SET @Day = (SELECT DATEDIFF(day, @LMPDate, GETDATE())%7)
			SET @GestationalAge = (CAST(@Week AS VARCHAR(5)) + '.' + CAST(@Day AS VARCHAR(5)))
		END
		ELSE
		BEGIN
			SET @GestationalAge = '0'
		END
	RETURN 	CONVERT(DECIMAL(10,1),@GestationalAge)
END