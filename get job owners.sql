SELECT  s.name ,
        SUSER_SNAME(s.owner_sid) AS owner
FROM    msdb..sysjobs s 
ORDER BY name