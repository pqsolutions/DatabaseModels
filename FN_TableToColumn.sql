USE [Eduquaydb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name='FN_TableToColumn' AND [type] = 'FN')
BEGIN
	DROP FUNCTION FN_TableToColumn
END
GO
CREATE FUNCTION [dbo].[FN_TableToColumn]
(
	@csvColumn NVARCHAR (4000)
	,@Delimiter NVARCHAR (2)
	,@value NVARCHAR(4000)
	,@search NVARCHAR(50) -- 'contains' | 'exact contains' | 'exact match'
)
RETURNS   NVARCHAR(1)
BEGIN
	DECLARE @return VARCHAR(1) = '0'
	DECLARE @table_ColumnValue TABLE (value NVARCHAR(100))
	DECLARE @table_InputValue TABLE (value NVARCHAR(100))
	DECLARE @joinCount INT
	DECLARE @valuecount INT
	DECLARE @Columnvaluecount INT
	INSERT INTO @table_ColumnValue  SELECT DISTINCT Item FROM  [dbo].[FN_SplitStringToTable](@csvColumn,@Delimiter)
	INSERT INTO @table_InputValue  SELECT DISTINCT Item  FROM  [dbo].[FN_SplitStringToTable](@value,@Delimiter)
	SELECT @joinCount =  COUNT(*) FROM @table_ColumnValue a INNER JOIN @table_InputValue b ON a.value = b.value
	SELECT @valuecount = COUNT(*) FROM @table_InputValue
	SELECT @Columnvaluecount = COUNT(*) FROM @table_ColumnValue	
	IF(@search = 'contains') 
	BEGIN
		IF @joinCount >0
			SET @return = '1'  
	END
	ELSE IF (@search = 'exact contains')
	BEGIN   
		IF(@joinCount = @valuecount)
			SET @return = '1' 
	END
	ELSE IF (@search = 'exact match')
	BEGIN
		IF( @joinCount = @valuecount and @joinCount= @Columnvaluecount )
			SET @return ='1'
	END
	RETURN @return
END

