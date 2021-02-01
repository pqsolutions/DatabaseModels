
USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GenerateUniqueSubjectId' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GenerateUniqueSubjectId
END
GO
CREATE FUNCTION [dbo].[FN_GenerateUniqueSubjectId]   
(
	@ANMID INT
	,@Source CHAR(1)
) 
RETURNS VARCHAR(250)        
AS    
BEGIN
	DECLARE
		@ANMCode  VARCHAR(100)
		,@UniqueSubjectId VARCHAR(MAX)
		,@StateID INT
		,@StateShortCode VARCHAR(10)
		,@LastUniqueId VARCHAR(MAX)
		,@LastUniqueId1 VARCHAR(MAX)
		,@ReturnValue VARCHAR(200)
		
		SELECT @ANMCode = User_gov_code
		   ,@StateID = StateID		
		   FROM Tbl_UserMaster WHERE ID = @ANMID
		   
		SELECT @StateShortCode = Shortname FROM Tbl_StateMaster WHERE ID = @StateID
	
		SET @LastUniqueId = (SELECT TOP 1 UniqueSubjectID 
			FROM Tbl_SubjectPrimaryDetail WITH(NOLOCK) WHERE AssignANM_ID = @ANMID  AND  UniqueSubjectID LIKE '%'+@Source      
			ORDER BY UniqueSubjectID DESC)
			
		SET @LastUniqueId1 =(SELECT ISNULL(LEFT(@LastUniqueId,(LEN(@LastUniqueId)-2)),''))
	
		SELECT @UniqueSubjectId = @StateShortCode + '/' + @ANMCode + '/' +     
			CAST(STUFF('00000',6-LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
			LEN(ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1),        
			CONVERT(VARCHAR,ISNULL(MAX(RIGHT(@LastUniqueId1,5)),0)+1)) AS NVARCHAR(15))+ '/'
			FROM Tbl_SubjectPrimaryDetail WHERE AssignANM_ID = @ANMID AND  UniqueSubjectID LIKE '%'+@Source 
			
		SET @ReturnValue = (Convert(VARCHAR(200),@UniqueSubjectId)+ CONVERT(VARCHAR(5),@Source)) --as UniqueSubjectId, ISNULL(@LastUniqueId,'') as PreviousUniqueSubjectId
	
		RETURN @ReturnValue
END        
