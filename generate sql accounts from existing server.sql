SELECT N'CREATE LOGIN ['+sp.[name]+'] FROM WINDOWS;'
FROM master.sys.server_principals AS sp
WHERE sp.[type] IN ('U', 'G') AND
      sp.is_disabled=0 AND
      sp.[name] NOT LIKE 'NT [AS]%\%';



SELECT N'CREATE LOGIN ['+sp.[name]+'] WITH PASSWORD=0x'+
       CONVERT(nvarchar(max), l.password_hash, 2)+N' HASHED, CHECK_POLICY=OFF, '+
       N'SID=0x'+CONVERT(nvarchar(max), sp.[sid], 2)+N';'
FROM master.sys.server_principals AS sp
INNER JOIN master.sys.sql_logins AS l ON sp.[sid]=l.[sid]
WHERE sp.[type]='S' AND sp.is_disabled=0;


/*
https://sqlsunday.com/2016/10/11/how-to-sync-logins-between-availability-group-replicas/
*/