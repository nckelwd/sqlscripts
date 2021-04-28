/*
Run Subscription to SSRS
-- Use Subscription Report.sql to find the job_id
*/
-- Run Agent Job
EXEC
msdb.dbo.sp_start_job @job_name = '6061197C-6F3D-4689-8F35-B43998659DB6'