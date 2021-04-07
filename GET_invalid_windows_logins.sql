
--Validate logins, returns users not in AD
exec sp_validatelogins


select [sid],name 
from sys.database_principals

EXEC sp_change_users_login report

--Drops users as indicated with loginname, but untested by me
--exec sp_dropuser loginname
--exec sp_droplogin loginname

/*
DROP USER IF EXISTS [SUDCO\BSacco]
DROP USER IF EXISTS [SUDCO\Bryan.sacco]
DROP USER IF EXISTS [SUDCO\Ciera.Johnson]
DROP USER IF EXISTS [SUDCO\Kellie.Hardee]
DROP USER IF EXISTS [SUDCO\Nilam.Keval]
DROP USER IF EXISTS [SUDCO\Laz.Magyar]
DROP USER IF EXISTS [SUDCO\igor.palija]
DROP USER IF EXISTS [SUDCO\Ankita.Uppal]
DROP USER IF EXISTS [SUDCO\dasharath.dixit]
DROP USER IF EXISTS [SUDCO\RRioux]
DROP USER IF EXISTS [SUDCO\JaronReed]
DROP USER IF EXISTS [SUDCO\John.Tran]
DROP USER IF EXISTS [SUDCO\Christopher.Petersen]
DROP USER IF EXISTS [SUDCO\Darren.Goedelman]
DROP USER IF EXISTS [SUDCO\John.Tran]
DROP USER IF EXISTS [SUDCO\Brad.Hackney]
DROP USER IF EXISTS [SUDCO\TBogle]
DROP USER IF EXISTS [SUDCO\Kyle.Howells]
DROP USER IF EXISTS [SUDCO\RMueller]
DROP USER IF EXISTS [SUDCO\AEarl]
SUDCO\Dave.Hessevick
SUDCO\JTran
SUDCO\KRozean
SUDCO\mgidron
SUDCO\MSaad
*/
