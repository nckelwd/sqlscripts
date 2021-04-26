/********************************************************************************************************************
Verify the db_executor role exists
********************************************************************************************************************/
USE AAD
GO

IF EXISTS (SELECT pr.name FROM sys.database_principals AS pr WHERE pr.name = 'db_executor')
	BEGIN
		PRINT 'The db_executor role already exists in this database.'
	END
ELSE 
	BEGIN
		CREATE ROLE db_executor GRANT EXECUTE TO db_executor
		PRINT 'The db_executor role has been created';
	END

/********************************************************************************************************************
Check where account exists on DB, then verfies it has the needed roles.
********************************************************************************************************************/
USE AAD
GO

DECLARE @userName VARCHAR(50)

SET @userName = 'simpl_hijump_app'

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @userName)
BEGIN
	DECLARE @UserSQL VARCHAR(200);
		SET @UserSQL = 'CREATE USER ' + @userName + ' FOR LOGIN ' + @userName;
	EXEC (@UserSQL);
	PRINT 'Created ' + @userName + ' on the database.';
END
ELSE
	PRINT 'The user ' + @userName + ' already exists on the database.'

DECLARE @rolesExec TABLE
(
	roleName VARCHAR(50)
)

INSERT INTO @rolesExec (roleName)
VALUES
	('db_datareader'),
	('db_datawriter'),
	('db_executor');

DECLARE @role VARCHAR(100)

DECLARE role_cursor CURSOR FOR
SELECT roleName
FROM @rolesExec

OPEN role_cursor

FETCH NEXT FROM role_cursor INTO @role

WHILE @@FETCH_STATUS = 0

BEGIN
	IF NOT EXISTS (
			SELECT DP1.name AS DatabaseRoleName,  
			   isnull (DP2.name, 'No members') AS DatabaseUserName  
			 FROM sys.database_role_members AS DRM
			 RIGHT OUTER JOIN sys.database_principals AS DP1
			   ON DRM.role_principal_id = DP1.principal_id
			 LEFT OUTER JOIN sys.database_principals AS DP2
			   ON DRM.member_principal_id = DP2.principal_id
			WHERE DP1.type = 'R'
			AND DP1.name = @role
			AND DP2.name = @userName
			)
		EXEC sp_addrolemember @role, @userName;
	ELSE 
		PRINT 'The user already has the ' + @role + ' role.';

FETCH NEXT FROM role_cursor INTO @role 
END

CLOSE role_cursor

DEALLOCATE role_cursor