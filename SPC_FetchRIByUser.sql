USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchRIByUser]    Script Date: 03/26/2020 00:12:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchRIByUser' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchRIByUser
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchRIByUser] (@UserId INT)
AS BEGIN
 SELECT R.[ID]    
		,(R.[RI_gov_code]  + ' - ' +  R.[RIsite] ) AS [RIsite]
		,R.[RI_gov_code]
		,R.[ILRID]
		,(I.[ILRCode] + ' - ' + I.[ILRPoint]) AS ILRPoint
		,R.[TestingCHCID]
		,(C.[CHC_gov_code] + ' - ' + C.[CHCname]) AS TestingCHCName
		,(SELECT A.[AVDName]
	FROM [dbo].[Tbl_AVDMaster] A	
	WHERE  A.[Isactive] = 1 AND '1' = [dbo].[FN_TableToColumn] (A.[RIID],',',R.[ID],'contains')) AS AVDName
		,(SELECT A.[ID]
	FROM [dbo].[Tbl_AVDMaster] A	
	WHERE  A.[Isactive] = 1 AND '1' = [dbo].[FN_TableToColumn] (A.[RIID],',',R.[ID],'contains')) AS AVDID
		,(SELECT A.[ContactNo]
	FROM [dbo].[Tbl_AVDMaster] A	
	WHERE  A.[Isactive] = 1 AND '1' = [dbo].[FN_TableToColumn] (A.[RIID],',',R.[ID],'contains')) AS AVDContactNo
 FROM [dbo].[Tbl_RIMaster] R
 LEFT JOIN [dbo].[Tbl_ILRMaster] I WITH (NOLOCK) ON I.ID = R.ILRID 
 LEFT JOIN [dbo].[Tbl_CHCMaster] C WITH (NOLOCK) ON C.ID = R.TestingCHCID 
 
 WHERE  R.[ID] IN (SELECT Value FROM dbo.[FN_Split]((SELECT isnull(RIID,'') FROM Tbl_UserMaster WHERE ID = @UserId),',')) AND R.[Isactive] = 1
END  