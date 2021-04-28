/*****************************************************************************************************************
Create User Accounts on Master
*****************************************************************************************************************/

DECLARE @userName VARCHAR(50)

SET @userName = 'user account name'

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @userName)
BEGIN
	DECLARE @LoginSQL VARCHAR(200);
		SET @LoginSQL = 'CREATE LOGIN ' + @userName + ' WITH PASSWORD = ''<random generated passowrd>''';
	EXEC (@LoginSQL);
END

/*****************************************************************************************************************
Create Group Accounts on Master - this might not be needed?
*****************************************************************************************************************/
/*
DECLARE @groupAzureRec TABLE(groupName VARCHAR(100))

INSERT INTO @groupAzureRec (groupName)
VALUES
	('[AZR_SQLServer_ServerName_Contributor]'),
	('[AZR_SQLServer_ServerName_Reader]'),
	('[AZR_SQLServer_ServerName_Owner]');

DECLARE @group VARCHAR(100)

DECLARE group_cursor CURSOR FOR
SELECT groupName
FROM @groupAzureRec

OPEN group_cursor

FETCH NEXT FROM group_cursor INTO @group

WHILE @@FETCH_STATUS = 0

BEGIN
	DECLARE @GroupSQL VARCHAR(300);
		SET @GroupSQL = 'CREATE USER ' + @group + ' FROM EXTERNAL PROVIDER';
	EXEC (@GroupSQL);
FETCH NEXT FROM group_cursor INTO @group 
END

CLOSE group_cursor

DEALLOCATE group_cursor
*/