USE [ReportServer$HYPATE];  -- You may change the database name. 
GO 

DECLARE @OldUserID uniqueidentifier
DECLARE @NewUserID uniqueidentifier
SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'sudco\Laz.Magyar'
SELECT @NewUserID = UserID FROM dbo.Users WHERE UserName = 'sudco\SVC-PVLXRPT01-SQLSRS'
UPDATE dbo.Subscriptions SET OwnerID = @NewUserID WHERE OwnerID = @OldUserID

/*
USE [ReportServer$HYPATE];  -- You may change the database name. 
GO 
--SELECT * FROM dbo.Subscriptions
SELECT * FROM dbo.Users --WHERE UserName = 'sudco\Laz.Magyar'
ORDER BY [UserName] ASC
*/