


USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_FetchHPLCTestedIDResults' AND [type] = 'FN')
BEGIN
	DROP FUNCTION [dbo].[FN_FetchHPLCTestedIDResults]
END 
GO
CREATE FUNCTION [FN_FetchHPLCTestedIDResults]     
(  
 @Barcode VARCHAR(250)
)   
RETURNS INT          
AS      
BEGIN  
	DECLARE  
		@Result VARCHAR(MAX)

	IF NOT EXISTS (SELECT ID FROM Tbl_HPLCTestedDetail WHERE Barcode = @Barcode)
	BEGIN
		SET @Result = 0
	END
	ELSE
	BEGIN

		SELECT  TOP 1 @Result = ID
		FROM Tbl_HPLCTestedDetail H WHERE H.Barcode = @Barcode AND ISNULL(H.ProcessStatus,0) = 0  AND H.SampleStatus  IS NULL 
		AND H.RunNo = (SELECT TOP 1 MAX(HD.RunNo) FROM Tbl_HPLCTestedDetail HD WHERE HD.Barcode = @Barcode) ORDER BY LEN(H.InjectionNo),H.ID DESC
	END
  
 RETURN  @Result  
END