

CREATE PROC [dbo].[SPC_GenerateDBDictionary] 
AS
BEGIN

	SELECT a.name [Table]
		,b.name [Attribute]
		,c.name [DataType]
		,b.length AS [Size]
		,b.isnullable [Allow Nulls?]
		,CASE WHEN d.name IS NULL THEN 0 ELSE 1 END [PKey?]
		,CASE WHEN e.parent_object_id IS NULL THEN 0 ELSE 1 END [FKey?]
		,CASE WHEN e.parent_object_id IS  NULL THEN '-' ELSE g.name  END [Ref Table]
		,CASE WHEN h.value IS NULL THEN '-' ELSE h.value END [Description]
	FROM sysobjects AS a
	JOIN syscolumns AS b ON a.id = b.id
	JOIN systypes AS c ON b.xtype = c.xtype 
	LEFT JOIN (SELECT  so.id,sc.colid,sc.name 
				FROM    syscolumns sc
				JOIN sysobjects so ON so.id = sc.id
				JOIN sysindexkeys si ON so.id = si.id AND sc.colid = si.colid
				WHERE si.indid = 1) d ON a.id = d.id and b.colid = d.colid
	LEFT JOIN sys.foreign_key_columns AS e ON a.id = e.parent_object_id and b.colid = e.parent_column_id    
	LEFT JOIN sys.objects as g on e.referenced_object_id = g.object_id  
	LEFT JOIN sys.extended_properties as h on a.id = h.major_id and b.colid = h.minor_id
	WHERE a.type = 'U' ORDER BY a.name

END