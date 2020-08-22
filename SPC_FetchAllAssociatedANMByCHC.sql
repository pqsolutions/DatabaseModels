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
	SELECT RI.[PHCID]
	,P.[PHCname] AS PHCName
	,RI.[SCID]
	,SC.[SCname] AS SCName
	,SC.[SCAddress]
	,SC.[Pincode]
	,RI.[ID] AS RIID
	,RI.[RIsite] AS RIPoint
	,RI.[ANMID] AS AssignANMID
	,(U.[FirstName] + ' ' +U.[LastName] ) AS ANMName
	,U.[ContactNo1] AS ContactNo 
	,RI.TestingCHCID
	,CM.[CHCname] AS TestingCHC
	,RI.[CHCID]
	FROM Tbl_RIMaster RI
	LEFT JOIN Tbl_CHCMaster C WITH (NOLOCK) ON  C.ID = RI.[CHCID]
	LEFT JOIN Tbl_SCMaster SC WITH (NOLOCK) ON SC.ID = RI.[SCID]
	LEFT JOIN Tbl_PHCMaster P WITH (NOLOCK) ON P.ID = RI.[PHCID]
	LEFT JOIN Tbl_CHCMaster CM WITH (NOLOCK) ON  CM.ID = RI.[TestingCHCID]
	LEFT JOIN Tbl_UserMaster U WITH (NOLOCK) ON U.ID = RI.[ANMID] 
	where RI.[CHCID] = @CHCId
END





