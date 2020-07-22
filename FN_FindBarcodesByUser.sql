


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FindBarcodesByUser' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FindBarcodesByUser]
END
GO
CREATE FUNCTION [dbo].[FN_FindBarcodesByUser]     
(  
 @SubjectID INT   
)   
RETURNS VARCHAR(MAX)          
AS      
BEGIN  
 
DECLARE @OutputBarcode VARCHAR(MAX),@Barcodes VARCHAR(max)
SELECT
@Barcodes=STUFF ((SELECT   BarcodeNo + ' | ' FROM Tbl_SampleCollection WHERE SubjectID=@SubjectId Order by id desc FOR XMl PATH('')) ,1,0,'')  
 
 SET @OutputBarcode = (SELECT LEFT(@Barcodes,LEN(@Barcodes)-2))
 RETURN  @OutputBarcode  
END