
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchBlockByDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchBlockByDistrict
END
GO
CREATE Procedure [dbo].[SPC_FetchBlockByDistrict] (@Id INT)
AS
BEGIN
	SELECT ID 
		,Blockname AS Name
	FROM Tbl_BlockMaster
	WHERE DistrictID = @Id		
END

