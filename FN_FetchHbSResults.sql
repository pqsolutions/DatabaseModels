


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchHbSResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchHbSResults]
END 
GO
CREATE FUNCTION [FN_FetchHbSResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS VARCHAR(100)          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)

	IF NOT EXISTS (SELECT HbS FROM Tbl_HPLCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = '--'
	END
	ELSE
	BEGIN

		SELECT  TOP 1 @Result =  CAST(ROUND( H.HbS,2) AS  DECIMAL(10,2))
		FROM Tbl_HPLCTestedDetail H WHERE H.Barcode = @Barcode AND ISNULL(H.ProcessStatus,0) = 0  AND H.IsValid  IS NULL 
		AND H.RunNo = (SELECT TOP 1 MAX(HD.RunNo) FROM Tbl_HPLCTestedDetail HD WHERE HD.Barcode = @Barcode) ORDER BY LEN(H.InjectionNo) DESC
	END
  
 RETURN  @Result  
END