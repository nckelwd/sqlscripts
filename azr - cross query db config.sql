/*****************************************************************************************************
Step 1: Run this againt the MASTER datbase
*****************************************************************************************************/
/***********************************************************
Create the datarefresh login on MASTER
***********************************************************/
CREATE LOGIN datarefresh WITH PASSWORD = '<password1>'


/*****************************************************************************************************
Step 2: Run this both the 'OLD' and 'NEW' database
*****************************************************************************************************/
/***********************************************************
Create the datarefresh user on each Database used in
the Cross-DB Query
***********************************************************/
CREATE USER datarefresh FROM LOGIN datarefresh

ALTER ROLE db_datareader ADD MEMBER datarefresh
ALTER ROLE db_datawriter ADD MEMBER datarefresh


/*****************************************************************************************************
Step 3: Run this on the restored PROD database/what will become the main database
*****************************************************************************************************/
/*****************************************************
Master Key
If no Master Key exists on the database, run this:

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'h&bas82mbga)%m2';
*****************************************************/

/*****************************************************
The first step is create a security credential:
*****************************************************/
CREATE DATABASE SCOPED CREDENTIAL DB2Security 
WITH IDENTITY = 'datarefresh',
SECRET = '<password1>';

/*****************************************************
The "username" and "password" should be the username 
and password used to login into the DB2 database.
*****************************************************/

/*****************************************************
Now you can use it to define a external datasource,
so DB1 can connect to DB2:
*****************************************************/
CREATE EXTERNAL DATA SOURCE DB2Access
WITH (
    TYPE=RDBMS,
    LOCATION='<oldserver>',
    DATABASE_NAME='<olddb>',
    CREDENTIAL= DB2Security);

/*****************************************************
Finally, you map the TB1 as a external table from 
the DB2 database, using the previous external datasource:
*****************************************************/
CREATE EXTERNAL TABLE dbo.UsersEXT(
	[SubjectId] [nvarchar](50) NULL,
	[TenantId] [nvarchar](50) NULL,
	[FamilyName] [nvarchar](200) NULL,
	[GivenName] [nvarchar](200) NULL,
	[Email] [nvarchar](500) NULL,
	[Phone] [nvarchar](50) NULL,
	[Deleted] [bit] NOT NULL,
)
WITH
(
    DATA_SOURCE = DB2Access,
	SCHEMA_NAME = 'dbo',
	OBJECT_NAME = 'Users');

/*****************************************************
Drop the External stuff as needed:

DROP EXTERNAL TABLE dbo.UsersEXT
DROP EXTERNAL DATA SOURCE DB2Access
DROP DATABASE SCOPED CREDENTIAL DB2Security
*****************************************************/


/*****************************************************************************************************
Step 4: Run this on the restored PROD database/what will become the main database
*****************************************************************************************************/
/***********************************************************
Remove the 'SubjectID' from the restored Production database
***********************************************************/
UPDATE Users
SET SubjectID = NULL

/***********************************************************
SELECTS & TRANSACTIONS

SELECT * FROM Users
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
***********************************************************/

/***********************************************************
Update the 'SubjectID' from the old database into the
'new' database
***********************************************************/
UPDATE u1 
SET u1.SubjectId = u2.SubjectId
FROM Users u1
LEFT JOIN UsersEXT u2 ON u1.Email = u2.Email
WHERE u2.SubjectId IS NOT NULL