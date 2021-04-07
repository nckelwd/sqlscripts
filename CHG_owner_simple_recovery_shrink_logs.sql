/*
Changes the Database to SIMPLE recovery mode, set's the Owner to 'sa', and shrinks the Log file
*/

--Change DB_NAME to database name

ALTER DATABASE DB_NAME SET RECOVERY SIMPLE
GO

USE DB_NAME
EXEC sp_changedbowner 'sa';
GO

USE DB_NAME
GO
DBCC SHRINKFILE (N'DB_NAME_Log' , 0, TRUNCATEONLY)
GO

/*
Checks the Log Resue Wait Desc for all databases, use if errors
*/

Use msdb
select name, log_reuse_wait, log_reuse_wait_desc from sys.databases

USE DB_NAME
SELECT * FROM sys.database_files