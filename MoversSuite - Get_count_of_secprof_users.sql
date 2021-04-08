USE MoversSuite2
GO

DECLARE @SecurityProfilesCount TABLE
(
	secProfName VARCHAR(50)
)

DECLARE @CountedTable TABLE
(
	secprof VARCHAR(50)
	,countof INT
)

INSERT INTO @SecurityProfilesCount (secProfName)
SELECT sp.description FROM MoversSuite2.dbo.SecurityProfile AS sp

DECLARE @name VARCHAR(100)

DECLARE SecProf_cursor CURSOR FOR
SELECT secProfName
FROM @SecurityProfilesCount

OPEN SecProf_cursor

FETCH NEXT FROM SecProf_cursor INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN	
	INSERT INTO @CountedTable (secprof,countof)
		  SELECT @name, COUNT (
		  sp.Description
		  )
	  FROM [MoversSuite2].[dbo].[SysuserBranch] AS syb
	  JOIN MoversSuite2.dbo.SysUser AS su
	  ON syb.SysuserPriKey = su.SysUserID
	  JOIN MoversSuite2.dbo.UserAccess AS ua
	  ON syb.SysuserPriKey = ua.SysUserID
	  JOIN MoversSuite2.dbo.SecurityProfile AS sp
	  ON ua.SecProfilePriKey = sp.SecProfilePriKey
	  WHERE syb.DefaultBranch = 1 AND su.Status = 1 AND sp.Description = @name
	
FETCH NEXT FROM SecProf_cursor INTO @name 
END

SELECT * FROM @CountedTable

CLOSE SecProf_cursor

DEALLOCATE SecProf_cursor

