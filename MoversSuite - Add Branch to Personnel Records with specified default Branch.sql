/*******************************************************************************************************************************************************
Insert Branch into users Branch list where the users default Branch = 1733
*******************************************************************************************************************************************************/

--BEGIN TRAN

USE MoversSuite2

DECLARE @BranchPriKey INT
DECLARE @BranchName varchar(30)

--Change this to the Branch you want to add
SET @BranchName = 'MIL XXXX' 

SELECT @BranchPriKey = [BranchPriKey] FROM MoversSuite2.dbo.Branch WHERE Name = @BranchName

IF OBJECT_ID(N'tempdb..#SysUserBranchTMP') IS NOT NULL DROP TABLE #SysUserBranch

CREATE TABLE #SysUserBranchTMP (
	[SysuserPriKey] [INT] NOT NULL,
	[BranchPriKey] [INT] NOT NULL,
	[DefaultBranch] [INT] NOT NULL,
)

INSERT INTO #SysUserBranchTMP (SysuserPriKey, BranchPriKey, DefaultBranch)

 --Change this BranchPriKey to the Default Branch of the users you would like to add the new branch to.
 --In this case, it's MIL 1733, prikey 22
SELECT SysuserPriKey, @BranchPriKey, 0
FROM [MoversSuite2].[dbo].[Sysuser] 
LEFT JOIN [MoversSuite2].[dbo].[SysuserBranch]
ON SysUserID = SysuserPriKey
Where BranchPriKey = 22 AND Status = 1

--Run this to review table before entering
--SELECT * FROM #SysUserBranchTMP

INSERT INTO [MoversSuite2].[dbo].[SysUserBranch] (SysuserPriKey, BranchPriKey, DefaultBranch)

SELECT SysuserPriKey, BranchPriKey, DefaultBranch FROM #SysUserBranchTMP

DROP TABLE #SysUserBranchTMP

--ROLLBACK TRAN
--COMMIT TRAN