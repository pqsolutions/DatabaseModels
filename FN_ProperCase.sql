--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_ProperCase' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_ProperCase
END
GO
CREATE FUNCTION [dbo].[FN_ProperCase]     
(  
	@SubjectName VARCHAR(250)  
)   
RETURNS VARCHAR(250)          
AS      
BEGIN  
	DECLARE  @Result VARCHAR(250)    
	SELECT @Result = UPPER(LEFT(@SubjectName, 1)) + LOWER(RIGHT(@SubjectName, LEN(@SubjectName) - 1))  
	RETURN  @Result  
END