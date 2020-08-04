


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindSampleType' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindSampleType]
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
 @SampleType CHAR(1)  
  SET @SampleType = 'F'  
  IF EXISTS(SELECT 1 FROM Tbl_SampleCollection WHERE SubjectID = @SubjectID)  
  BEGIN  
   SET @SampleType = 'R'  
  END  
 RETURN  @SampleType  
END