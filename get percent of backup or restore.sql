select percent_complete,* from sys.dm_exec_requests 
where command='BACKUP DATABASE'

SELECT r.session_id,r.command,CONVERT(NUMERIC(6,2),r.percent_complete)
AS [PERCENT Complete],CONVERT(VARCHAR(20),DATEADD(ms,r.estimated_completion_time,GETDATE()),20) AS [ETA COMPLETION TIME],
CONVERT(NUMERIC(6,2),r.total_elapsed_time/1000.0/60.0) AS [Elapsed MIN],
CONVERT(NUMERIC(6,2),r.estimated_completion_time/1000.0/60.0) AS [ETA MIN],
CONVERT(NUMERIC(6,2),r.estimated_completion_time/1000.0/60.0/60.0) AS [ETA Hours],
CONVERT(VARCHAR(100),(SELECT SUBSTRING(TEXT,r.statement_start_offset/2,
CASE WHEN r.statement_end_offset = -1 THEN 1000 ELSE (r.statement_end_offset-r.statement_start_offset)/2 END)
FROM sys.dm_exec_sql_text(sql_handle)))
FROM sys.dm_exec_requests r WHERE command IN ('RESTORE DATABASE','BACKUP DATABASE')