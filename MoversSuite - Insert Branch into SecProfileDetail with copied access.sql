/*************************************************************************************************************************
Insert Branch in Security Profiles with copied access from MIL 1733 (SUVL) branch
*************************************************************************************************************************/

USE MoversSuite2

DECLARE @BranchPriKey INT

 --Change this to match the branch name you want to add to Security Profile
SELECT @BranchPriKey = [BranchPriKey]
FROM MoversSuite2.dbo.Branch
WHERE Name = 'MIL 9979'

IF OBJECT_ID(N'tempdb..#SecProfDetTemp') IS NOT NULL DROP TABLE #SecProfDetTemp

CREATE TABLE #SecProfDetTemp(
	[SecProfilePriKey] [INT] NOT NULL,
	[ModulePriKey] [INT] NOT NULL,
	[BranchPriKey] [INT] NOT NULL,
	[AccessPriKey] [INT] NOT NULL,
	[ManagerFlag] [BIT] NOT NULL,
)

INSERT INTO #SecProfDetTemp (SecProfilePriKey, ModulePriKey, BranchPriKey, AccessPriKey, ManagerFlag)

--22 is the PriKey for 'MIL 1733 (SUVL), change this number to the corresponding BranchPriKey you would like to copy
SELECT SecProfilePriKey, ModulePriKey, @BranchPriKey, AccessPriKey, ManagerFlag
FROM [MoversSuite2].[dbo].[SecProfileDetail] 
WHERE BranchPriKey = 22;

--Run this to review table before entering
--SELECT * FROM #SecProfDetTemp

INSERT INTO [MoversSuite2].[dbo].[SecProfileDetail] (SecProfilePriKey, ModulePriKey, BranchPriKey, AccessPriKey,ManagerFlag)

SELECT SecProfilePriKey, ModulePriKey, BranchPriKey, AccessPriKey, ManagerFlag FROM #SecProfDetTemp;

DROP TABLE #SecProfDetTemp