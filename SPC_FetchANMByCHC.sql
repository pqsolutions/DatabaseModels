
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




IF EXISTS (SELECT 1 FROM sys.objects WHERE name='SPC_FetchANMByCHC' AND [type] = 'p')
BEGIN
	DROP PROCEDURE SPC_FetchANMByCHC 
END
GO
CREATE Procedure [dbo].[SPC_FetchANMByCHC] (@Id INT)
AS
BEGIN
	SELECT ID 
		,(FirstName + ' ' +LastName) AS Name
	FROM Tbl_UserMaster
	WHERE CHCID = @Id	AND  UserType_ID IN (SELECT ID FROM Tbl_UserTypeMaster WHERE Usertype = 'ANM')
	ORDER BY FirstName
END

