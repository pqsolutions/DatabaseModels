USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchRIByPincode' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchRIByPincode
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchRIByPincode] (@Pincode VARCHAR(150))
AS BEGIN
 SELECT R.[ID]    
		,(R.[RI_gov_code]  + ' - ' +  R.[RIsite] ) AS [RIsite]
		,R.[RI_gov_code]
 FROM [dbo].[Tbl_RIMaster] R
 WHERE R.[Pincode] =  @Pincode
END  