--USE [Eduquaydb]
GO
/****** Object:  StoredProcedure [dbo].[SPC_FetchAllStates]    Script Date: 03/26/2020 00:05:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM SYS.ObJECTS WHERE NAME='SPC_FetchAllStates' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchAllStates
END
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllStates]
AS
BEGIN
	SELECT [ID]
		,[Statename]
		,[Shortname]
		,[State_gov_code]
		,[Isactive]
		,[Comments] 
		,[Createdby] 
		,[Updatedby]      
	FROM [dbo].[Tbl_StateMaster] --WHERE ID = 1
	ORDER BY [ID]
END
