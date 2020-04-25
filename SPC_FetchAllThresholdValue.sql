USE [Eduquaydb]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



IF EXISTS (Select 1 from sys.objects where name='SPC_FetchAllThresholdValue' and [type] = 'p')
Begin
	DROP PROCEDURE SPC_FetchAllThresholdValue
End
GO
CREATE PROCEDURE [dbo].[SPC_FetchAllThresholdValue]
As
BEGIN
	SELECT TV.[ID]
		 ,TV.[TestTypeID]
		 ,TT.[TestType]
		 ,TV.[TestName]
		 ,TV.[ThresholdValue]
		 ,TV.[Isactive]
		 ,TV.[Comments] 
		 ,TV.[Createdby] 
		 ,TV.[Updatedby]      
	FROM [dbo].[Tbl_ThresholdValueMaster] TV
	LEFT JOIN [dbo].[Tbl_TestTypeMaster] TT WITH (NOLOCK) ON TT.ID = TV.TestTypeID
	ORDER BY TV.[ID]
END

