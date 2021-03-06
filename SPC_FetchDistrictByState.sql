USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchDistrictByState]    Script Date: 03/26/2020 00:08:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchDistrictByState' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchDistrictByState
END
GO
CREATE Procedure [dbo].[SPC_FetchDistrictByState] (@Id INT)
AS
BEGIN
	SELECT D.[ID]
		,(D.[District_gov_code] + ' - ' + D.[Districtname]) AS  Districtname
		,D.[District_gov_code] 	
	FROM [dbo].[Tbl_DistrictMaster] D
	LEFT JOIN [dbo].[Tbl_StateMaster] S WITH (NOLOCK) ON S.ID = D.StateID	
	WHERE D.StateID  = @Id	AND D.[Isactive] = 1
END

