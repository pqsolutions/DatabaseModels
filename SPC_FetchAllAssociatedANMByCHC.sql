USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchAllAssociatedANMByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllAssociatedANMByCHC
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllAssociatedANMByCHC] (@CHCId VARCHAR(10))
AS
BEGIN
	SELECT P.[ID] AS PHCID
	,P.[PHCname] AS PHCName
	,SC.[ID] AS SCID
	,SC.[SCname] AS SCName
	,SC.[SCAddress]
	,SC.[Pincode]
	,RI.[ID] AS RIID
	,RI.[RIsite] AS RIPoint
	,(SELECT ID FROM Tbl_UserMaster WHERE  '1' = [dbo].[FN_TableToColumn] ([RIID],',',RI.[ID],'contains')) AS AssignANMID
	,(SELECT (FirstName +' '+LastName)FROM Tbl_UserMaster WHERE  '1' = [dbo].[FN_TableToColumn] ([RIID],',',RI.[ID],'contains'))AS ANMName
	,(SELECT ContactNo1 FROM	Tbl_UserMaster WHERE  '1' = [dbo].[FN_TableToColumn] ([RIID],',',RI.[ID],'contains'))AS ContactNo
	,CM.TestingCHCID
	,C.[CHCname] AS TestingCHC
	FROM Tbl_CHCMaster CM
	LEFT JOIN Tbl_CHCMaster C WITH (NOLOCK) ON C.[ID] = CM.[TestingCHCID]
	LEFT JOIN Tbl_PHCMaster P WITH (NOLOCK) ON P.[CHCID] = CM.[ID]
	LEFT JOIN Tbl_SCMaster SC WITH (NOLOCK) ON SC.[CHCID] = CM.[ID]
	LEFT JOIN Tbl_RIMaster RI WITH (NOLOCK) ON SC.[ID] = RI.[SCID]
	where CM.[ID] = @CHCId
END





