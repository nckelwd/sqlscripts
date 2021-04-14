/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [ReportServer].[dbo].[RunningJobs]


USE ReportServer;
GO
SELECT TOP (5) el2.username, 
el2.InstanceName, 
el2.ReportPath, 
el2.TimeStart, 
el2.TimeEnd, 
el2.[Status],
isnull(el2.Parameters, 'N/A') as Parameters 
FROM ExecutionLog2 el2
WHERE el2.ReportPath IN (Select RequestPath FROM [ReportServer$EDISON].[dbo].[RunningJobs])
ORDER BY TimeStart DESC
GO