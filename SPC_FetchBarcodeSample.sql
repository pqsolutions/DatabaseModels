USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchBarcodeSample' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchBarcodeSample
End
GO
CREATE Procedure [dbo].[SPC_FetchBarcodeSample] (@Barcode VARCHAR(200))
as
Begin
	SELECT TOP 1 BarcodeNo      
	FROM [dbo].[Tbl_SampleCollection]  where BarcodeNo  = @Barcode		
End

