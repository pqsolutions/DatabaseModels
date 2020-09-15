USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_GetMTPSubjectComplications' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_GetMTPSubjectComplications
END
GO
CREATE FUNCTION [dbo].[FN_GetMTPSubjectComplications]   
(
	@MTPTestID INT	
) 
RETURNS VARCHAR(MAX)        
AS    
BEGIN
	DECLARE
		@Indexvar INT
		,@TotalCount INT
		,@CurrentIndex NVARCHAR(200)
		,@ComplecationsId VARCHAR(100)
		,@ComplicationsName VARCHAR(MAX)
		,@Complications VARCHAR(MAX) = ''
		,@MTPComplecations VARCHAR(MAX)
		
		SELECT @ComplecationsId = MTPComplecationsId  FROM Tbl_MTPTest WHERE ID = @MTPTestID
		SET @IndexVar = 0 
		SELECT @TotalCount = COUNT(value) FROM [dbo].[FN_Split](ISNULL(@ComplecationsId,0),',')
		WHILE @Indexvar < @TotalCount  
		BEGIN
			SELECT @IndexVar = @IndexVar + 1
			SELECT @CurrentIndex = Value FROM  [dbo].[FN_Split](ISNULL(@ComplecationsId,0),',') WHERE id = @Indexvar
			SELECT @ComplicationsName = ComplecationsName FROM Tbl_MTPComplicationsMaster WHERE ID = CAST(@CurrentIndex AS INT)
			SET @Complications = @Complications + @ComplicationsName + ', '
		END
		SET @MTPComplecations = (SELECT LEFT(@Complications,LEN(@Complications)-1))
		
	RETURN 	@MTPComplecations
END