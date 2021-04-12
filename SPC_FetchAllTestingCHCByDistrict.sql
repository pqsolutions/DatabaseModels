--USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllTestingCHCByDistrict' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllTestingCHCByDistrict
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllTestingCHCByDistrict] (@Id INT)
AS BEGIN
 SELECT [ID]    
		,([CHC_Gov_Code]  + ' - ' +  [CHCname]) AS name
 FROM   [dbo].[Tbl_CHCMaster] 
 WHERE Istestingfacility = 1 AND DistrictID = @Id
END  