--Start by storing all of the fields to be updated
DECLARE @tablevar TABLE 
(
	ID INT IDENTITY(1,1)
	, TABLE_NAME VARCHAR(255)
	, FIELD_NAME VARCHAR(255)
)
INSERT INTO @email_fields (TABLE_NAME, FIELD_NAME)
    SELECT 'table_name', 'column_field_name'
	UNION SELECT 'table_name', 'column_field_name'

--grab IDs for iteration
DECLARE @this_id INT
DECLARE @max_id INT
SELECT
	@this_id = min(ID)
	, @max_id = max(ID)
FROM
	@email_fields

--set up fields for looping
DECLARE @sql NVARCHAR(1000)
DECLARE @this_sql NVARCHAR(1000)

SET @sql = N'

ALTER TABLE [@table_name] DISABLE TRIGGER ALL

UPDATE [@table_name]
SET
	[@field_name] = ''NULL@NULL.NULL''
WHERE
	[@field_name] IS NOT NULL
	AND [@field_name] NOT LIKE ''%domain.com''
	
ALTER TABLE [@table_name] ENABLE TRIGGER ALL
'

--loop through fields, updating emails
DECLARE 
	@this_table_name NVARCHAR(255)
	, @this_field_name NVARCHAR(255)

WHILE @this_id <= @max_id
BEGIN
	--grab this table and field
	SELECT
		@this_table_name = TABLE_NAME
		, @this_field_name = FIELD_NAME
	FROM
		@email_fields
	WHERE
		ID = @this_id

	--generate SQL
	SET @this_sql = REPLACE(@sql, '@table_name', @this_table_name)
	SET @this_sql = REPLACE(@this_sql, '@field_name', @this_field_name)

	--execute (or print for debugging)
	--PRINT @this_sql
	EXECUTE (@this_sql)

	--prepare next loop
	SET @this_id = @this_id + 1
END

