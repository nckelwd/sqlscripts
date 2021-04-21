/****************************************************************************************
Adding a MIL SCAC/Managed SCAC to MoversSuite
****************************************************************************************/


/****************************************************************************************
Use the key below to locate and replace the information to match the MIL SCAC you are adding to MoversSuite

Agent Number		9979
Agent Name			FULL AGENT NAME
SCAC Code			XYZX
Server\DB			DVJAXSDBXDB01ST\MSGPSNDBX --Currently not using this variable
Branch GL Code		8878
Company GL Code		2117

****************************************************************************************/


/****************************************************************************************
Create an Agent entry in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @AgentID VARCHAR(10),@AgentName VARCHAR(30)

--If the SCAC is United, make sure the prefix for the Agent ID is U ; if Mayflower, use M.

SET @AgentID = 'U9979';
SET @AgentName = 'FULL AGENT NAME';

INSERT INTO [MoversSuite2].[dbo].[Agent](AgentID,Name,County,Memo,VLPriKey,VendorID,IsActive,HaulOwnAuthority,HaulVanLineAuthority,IsForwardingAgent)
VALUES(@AgentID,@AgentName,NULL,NULL,2,NULL,1,0,0,0);

--SELECT * FROM MoversSuite2.dbo.Agent WHERE AgentID = 'U9979'

/****************************************************************************************
Create a GL Control Code entry in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @AgentCode VARCHAR(10)--,@ServerDBName VARCHAR(50)

SET @AgentCode = 'XYZX';
--SET @ServerDBName = 'DVJAXSDBXDB01ST\MSGPSNDBX';

INSERT INTO [MoversSuite2].[dbo].[GLControl](Description,AServer,ADataBase,CustomerNumber,DynamicsDbName)
VALUES(@AgentCode,'SUDDATH37\Edison','SRS','ZZZZZZ','DYNAMICS');

--SELECT * FROM MoversSuite2.dbo.GLControl WHERE Description = 'XYZX'

/****************************************************************************************
Create a Branch entry in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @AgentCode VARCHAR(10),@BranchDispName VARCHAR(30),@AgentPriKeyV INT,@VanLineType INT,@BranchGLCode INT,@GLControlPriKey INT

--The Branch Display Name for SCACs is different from the Agent Name normally used when adding a branch; Here, we predicate the Agent Number with 'MIL '
--The Van Line Type can also be changed to align with the Move Authority; Here, we are using (2) Own Authority

SET @AgentCode = 'XYZX';
SET @BranchDispName = 'MIL 9979';
SET @VanLineType = 2;
SET @BranchGLCode = '8878';


SELECT @AgentPriKeyV = [AgentPriKey] FROM MoversSuite2.dbo.Agent WHERE AgentID = 'U9979' 
--SELECT @GLControlPriKey = [GLCPriKey] FROM MoversSuite2.dbo.GLControl WHERE Description = 'U9979'

INSERT INTO [MoversSuite2].[dbo].[Branch](BranchID,Name,AgentPriKey,Prefix,Sequence,GLCode,GLCPriKey,VLPriKey,CompanyGLCode,CommonView,ImageURL,DOT,AdvanceCompanyNumber,AdvanceFTPHostDirectory,AuthorityTypeFID,SalesTaxCompanyCode,CostBenefitsPercentage,DefaultDriveTime,LaborRatingGroupFID,MssTimeZoneFID)
VALUES(@AgentCode,@BranchDispName,@AgentPriKeyV,NULL,0,@BranchGLCode,130,@VanLineType,2117,NULL,NULL,NULL,'SU001','movers',1,NULL,NULL,NULL,NULL,NULL);


--SELECT * FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX';

/****************************************************************************************
Create Order Number entries in MoversSuite (Part 1)
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @OADescription VARCHAR(25),@AgentCode VARCHAR(10)

SET @OADescription = '9979 Own Authority';
SET @AgentCode = 'XYZX';


INSERT INTO [MoversSuite2].[dbo].[OrderNumbers](Description,Prefix,Minimum,Maximum,YearLength,NextYear,CurrentYear,NextNoInSeq,NextYrNextNo,VanlineFID)
VALUES(@OADescription,@AgentCode,1,99999,2,2022,2021,1,1,NULL);

--SELECT * FROM [MoversSuite2].[dbo].[OrderNumbers] WHERE Description = '9979 Own Authority'

/****************************************************************************************
Create Order Number entries in MoversSuite (Part 2)
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @VLADescription VARCHAR(25),@AgentNum VARCHAR(10)

SET @VLADescription = '9979 Van Lines Authority';
SET @AgentNum = '9979';

INSERT INTO [MoversSuite2].[dbo].[OrderNumbers](Description,Prefix,Minimum,Maximum,YearLength,NextYear,CurrentYear,NextNoInSeq,NextYrNextNo,VanlineFID)
VALUES(@VLADescription,@AgentNum,1001,99999,1,2022,2021,1001,1001,2);

--SELECT * FROM [MoversSuite2].[dbo].[OrderNumbers] WHERE Description = '9979 Van Lines Authority'

/****************************************************************************************
Create Move Type entries in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @VLAPriKey INT,@OAPriKey INT, @AgentCode VARCHAR(10)

SELECT @AgentCode = [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX'
SELECT @OAPriKey = [OrderNumbersID] FROM MoversSuite2.dbo.OrderNumbers WHERE Prefix = 'XYZX'
SELECT @VLAPriKey = [OrderNumbersID] FROM MoversSuite2.dbo.OrderNumbers WHERE Prefix = '9979'

INSERT INTO [MoversSuite2].[dbo].[MoveType](MoveName,IsLongDistanceDispatch,OrderNumbersID,BranchPriKey,MTGroupPriKey,ManualOrderNumber,Inactive,InternationalAutoRegister)
VALUES('Cancelled Move',0,NULL,@AgentCode,22,0,0,0);

INSERT INTO [MoversSuite2].[dbo].[MoveType](MoveName,IsLongDistanceDispatch,OrderNumbersID,BranchPriKey,MTGroupPriKey,ManualOrderNumber,Inactive,InternationalAutoRegister)
VALUES('Interstate',1,NULL,@AgentCode,22,0,0,0);

INSERT INTO [MoversSuite2].[dbo].[MoveType](MoveName,IsLongDistanceDispatch,OrderNumbersID,BranchPriKey,MTGroupPriKey,ManualOrderNumber,Inactive,InternationalAutoRegister)
VALUES('Mil Inter Oth',1,@OAPriKey,@AgentCode,14,0,0,0);

INSERT INTO [MoversSuite2].[dbo].[MoveType](MoveName,IsLongDistanceDispatch,OrderNumbersID,BranchPriKey,MTGroupPriKey,ManualOrderNumber,Inactive,InternationalAutoRegister)
VALUES('Mil Inter UVL',1,@VLAPriKey,@AgentCode,14,0,0,0);

INSERT INTO [MoversSuite2].[dbo].[MoveType](MoveName,IsLongDistanceDispatch,OrderNumbersID,BranchPriKey,MTGroupPriKey,ManualOrderNumber,Inactive,InternationalAutoRegister)
VALUES('Mil Intra',1,@OAPriKey,@AgentCode,16,0,0,0);


--SELECT * FROM [MoversSuite2].[dbo].[MoveType] WHERE BranchPriKey = (SELECT [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX')

/****************************************************************************************
Create an Service Type entry in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

Use MoversSuite2
GO

DECLARE @AgentCode VARCHAR(10)

SELECT @AgentCode = [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX'

INSERT INTO [MoversSuite2].[dbo].[ServType](Service,LaborType,UnitsPerHour,ICPriKey,BranchPriKey,ServTypeGPriKey,StorageFlagIn,StorageFlagOut,ManualEntryHoursFlag,ContainerizationEligibleFlag,Inactive,ServTypeClassFID,AvailableToOrderInformation,AvailableToInternational,AvailableToSpecialServices,AvailableToOfficeIndustrial,UnitTypeFID)
VALUES('Do Not Request Service Fm 9979','No Provider',1,NULL,@AgentCode,NULL,0,0,0,0,0,NULL,1,1,1,0,1);

--SELECT * FROM [MoversSuite2].[dbo].[ServType] WHERE BranchPriKey = (SELECT [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX')

/****************************************************************************************
Add XML Interfaces to existing entries in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @AgentCode VARCHAR(10)

SELECT @AgentCode = [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX'

INSERT INTO [MoversSuite2].[dbo].[XmlInterfaceBranch](XmlInterfaceFID,BranchFID,AuthorityFID,ExternalCode)
VALUES(1,@AgentCode,2,NULL)

INSERT INTO [MoversSuite2].[dbo].[XmlInterfaceBranch](XmlInterfaceFID,BranchFID,AuthorityFID,ExternalCode)
VALUES(6,@AgentCode,1,NULL)

--SELECT * FROM [XmlInterfaceBranch] WHERE BranchFID = (SELECT [BranchPriKey] FROM [MoversSuite2].[dbo].[Branch] WHERE BranchID = 'XYZX')

/****************************************************************************************
Create Military Carrier entry in MoversSuite
BEGIN TRAN
ROLLBACK TRAN
COMMIT TRAN
****************************************************************************************/

USE MoversSuite2
GO

DECLARE @AgentName VARCHAR(30)
DECLARE @AgentCode VARCHAR(10)

SET @AgentName = 'FULL AGENT NAME';
SET @AgentCode = 'XYZX';

INSERT INTO [MoversSuite2].[dbo].[MilitaryCarrier](Name,Contact,EMail,FederalIDNumber,DunsNumber,SCACNumber,BranchFID)
VALUES(@AgentName,NULL,NULL,NULL,NULL,@AgentCode,NULL)

--SELECT * FROM [MilitaryCarrier] WHERE SCACNumber = 'XYZX'
