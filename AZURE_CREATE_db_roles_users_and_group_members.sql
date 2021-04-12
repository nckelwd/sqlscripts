/*****************************************************************************************************************
Check db for roles, add them as needed on DATABASE
*****************************************************************************************************************/

--USE [DATABASE NAME]

IF EXISTS (SELECT pr.name FROM sys.database_principals AS pr WHERE pr.name = 'db_executor')
	BEGIN
		PRINT 'The db_executor role already exists in this database.'
	END
ELSE 
	BEGIN
		CREATE ROLE db_executor GRANT EXECUTE TO db_executor
		PRINT 'The db_executor role has been created';
	END

IF EXISTS (SELECT pr.name FROM sys.database_principals AS pr WHERE pr.name = 'db_viewdefinition')
	BEGIN
		PRINT 'The db_viewdefinition role already exists in this database.'
	END
ELSE 
	BEGIN
		CREATE ROLE db_viewdefinition GRANT VIEW DEFINITION TO db_viewdefinition
		PRINT 'The db_viewdefinition role has been created';
	END

/*****************************************************************************************************************
Create User Accounts on DATABASE
*****************************************************************************************************************/

DECLARE @userName VARCHAR(50)

SET @userName = 'user account name'

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @userName)
BEGIN
	DECLARE @UserSQL VARCHAR(200);
		SET @UserSQL = 'CREATE USER ' + @userName + ' FOR LOGIN ' + @userName;
	EXEC (@UserSQL);
END

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
	EXEC sp_addrolemember @role, @userName
FETCH NEXT FROM role_cursor INTO @role 
END

CLOSE role_cursor

DEALLOCATE role_cursor

/*****************************************************************************************************************
Create User Groups on DATABASE
*****************************************************************************************************************/

DECLARE @groupAzureC VARCHAR(100);
DECLARE @groupAzureR VARCHAR(100);
DECLARE @groupAzureO VARCHAR(100);

SET @groupAzureC = '[AZR_SQLServer_ServerName_Contributor]'
SET @groupAzureR = '[AZR_SQLServer_ServerName_Reader]'
SET @groupAzureO = '[AZR_SQLServer_ServerName_Owner]'

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @groupAzureC)
BEGIN
	DECLARE @GroupSQL1 VARCHAR(200);
		SET @GroupSQL1 = 'CREATE USER ' + @groupAzureC + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER ' + @groupAzureC;
	EXEC (@GroupSQL1);
	DECLARE @GroupSQL2 VARCHAR(200);
		SET @GroupSQL2 = 'CREATE USER ' + @groupAzureC + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_datawriter ADD MEMBER ' + @groupAzureC;
	EXEC (@GroupSQL2);
	DECLARE @GroupSQL3 VARCHAR(200);
		SET @GroupSQL3 = 'CREATE USER ' + @groupAzureC + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_ddladmin ADD MEMBER ' + @groupAzureC;
	EXEC (@GroupSQL3);
	DECLARE @GroupSQL4 VARCHAR(200);
		SET @GroupSQL4 = 'CREATE USER ' + @groupAzureC + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_executor ADD MEMBER ' + @groupAzureC;
	EXEC (@GroupSQL4);
END

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @groupAzureR)
BEGIN
	DECLARE @GroupSQL5 VARCHAR(200);
		SET @GroupSQL5 = 'CREATE USER ' + @groupAzureR + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER ' + @groupAzureR;
	EXEC (@GroupSQL5);
END

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = @groupAzureO)
BEGIN
	DECLARE @GroupSQL6 VARCHAR(200);
		SET @GroupSQL6 = 'CREATE USER ' + @groupAzureO + ' FROM EXTERNAL PROVIDER; ALTER ROLE db_owner ADD MEMBER ' + @groupAzureO;
	EXEC (@GroupSQL6);
END