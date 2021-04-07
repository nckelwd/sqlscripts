USE [ReportServer$HYPATE];  -- You may change the database name. 
GO 

SELECT b.NAME AS JobName
,a.SubscriptionID
,e.NAME
,e.Path
,d.Description
,d.LastStatus
,d.EventType
,d.LastRunTime
,b.date_created
,b.date_modified
FROM ReportServer$HYPATE.dbo.ReportSchedule AS a
INNER JOIN msdb.dbo.sysjobs AS b ON CAST(a.ScheduleID AS SYSNAME) = b.NAME
INNER JOIN ReportServer$HYPATE.dbo.ReportSchedule AS c ON b.NAME = CAST(c.ScheduleID AS SYSNAME)
INNER JOIN ReportServer$HYPATE.dbo.Subscriptions AS d ON c.SubscriptionID = d.SubscriptionID
INNER JOIN ReportServer$HYPATE.dbo.CATALOG AS e ON d.Report_OID = e.ItemID
ORDER BY d.[DESCRIPTION]



-- List all SSRS subscriptions 
USE [ReportServer$HYPATE];  -- You may change the database name. 
GO 
 
SELECT USR.UserName AS SubscriptionOwner 
      ,SUB.ModifiedDate 
      ,SUB.[Description] 
      ,SUB.EventType 
      ,SUB.DeliveryExtension 
      ,SUB.LastStatus 
      ,SUB.LastRunTime 
      ,SCH.NextRunTime 
      ,SCH.Name AS ScheduleName       
      ,CAT.[Path] AS ReportPath 
      ,CAT.[Description] AS ReportDescription 
FROM dbo.Subscriptions AS SUB 
     INNER JOIN dbo.Users AS USR 
         ON SUB.OwnerID = USR.UserID 
     INNER JOIN dbo.[Catalog] AS CAT 
         ON SUB.Report_OID = CAT.ItemID 
     INNER JOIN dbo.ReportSchedule AS RS 
         ON SUB.Report_OID = RS.ReportID 
            AND SUB.SubscriptionID = RS.SubscriptionID 
     INNER JOIN dbo.Schedule AS SCH 
         ON RS.ScheduleID = SCH.ScheduleID 
ORDER BY USR.UserName 
        ,CAT.[Path];
