/*标签Labels*/
INSERT INTO HtmlLabelIndex values(17159,'项目审批单据') 
GO
INSERT INTO HtmlLabelInfo VALUES(17159,'项目审批单据',7) 
GO
INSERT INTO Prj_ProjectStatus (fullname,description) values ('审批退回','审批退回')
GO
/*项目审批单据*/
CREATE TABLE Bill_ApproveProj ( 
    id int IDENTITY,
    ApproveID INT,
    Manager int,
    requestid int) 
GO
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(74,17159,'Bill_ApproveProj','AddApproveProj.jsp','ManageApproveProj.jsp','ViewApproveProj.jsp','','','BillApproveProjOperation.jsp') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (74,'Manager',16573,'int',3,1,1,0) 
GO


ALTER  PROCEDURE Prj_ProjectType_SelectAll (@flag	[int]	output, @msg	[varchar](80)	output) AS 

SELECT type.* ,base.workflowname FROM  [Prj_ProjectType] type 
LEFT JOIN Workflow_base base ON (type.wfid = base.id)

set @flag = 1 set @msg = 'OK!'
GO

ALTER  PROCEDURE Prj_ProjectType_SelectByID (@id 	[int], @flag	[int]	output, @msg	[varchar](80)	output) AS 

SELECT type.*,base.workflowname FROM Prj_ProjectType type 
LEFT JOIN Workflow_base base ON (type.wfid = base.id)
WHERE ( type.id	 = @id) 

set @flag = 1 set @msg = 'OK!'
GO

/*会议*/
/*标签*/
INSERT INTO HtmlLabelIndex values(17219,'会议审批单') 
GO
INSERT INTO HtmlLabelInfo VALUES(17219,'会议审批单',7) 
GO
/*会议类型浏览筐*/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 89,2104,'INT','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingTypeBrowser.jsp','Meeting_Type','name','id','/meeting/Maint/ListMeetingType.jsp?id=')
GO

/*修改会议浏览筐的链接地址*/
UPDATE workflow_browserurl
SET LinkUrl = '/meeting/data/ViewMeeting.jsp?isrequest=1&meetingid='
WHERE ID = 28

GO
/*会议审批单据*/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(85,17219,'Bill_Meeting','AddBillMeeting.jsp','ManageBillMeeting.jsp','ViewBillMeeting.jsp','','','BillMeetingOperation.jsp') 
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'MeetingType',2104,'INT',3,89,0,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'MeetingName',2151,'varchar(255)',1,1,1,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Caller',2152,'INT',3,1,2,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Contacter',572,'INT',3,1,3,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'BeginDate',740,'varchar(10)',3,2,4,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'BeginTime',742,'Varchar(8)',3,19,5,0)
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'EndDate',741,'Varchar(10)',3,2,6,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'EndTime',743,'Varchar(8)',3,19,7,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Address',2105,'INT',3,87,8,0) 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'ApproveID',926,'INT',3,28,9,0)
Go
CREATE TABLE Bill_Meeting ( 
    id int IDENTITY,
    ApproveID INT,
    MeetingType INT,
    MeetingName varchar(255),
    Caller INT,
    Contacter INT,
    BeginDate varchar(10),
    BeginTime Varchar(8),
    EndDate Varchar(10),
    EndTime Varchar(8),
    Address INT,
    requestid int) 
GO
/*修改会议表，增加两列*/
Alter table Meeting 
	add meetingstatus int not null default 0,
	    requestid int not null default 0
go
/*修改项目表，添加requestid列*/
Alter Table  Prj_ProjectInfo
	 Add requestid int not null default 0
go

/*审批任务*/

/*新增April 21,2004 任务更改历史表*/
Create TABLE Prj_TaskModifyLog  (
ID	   INT IDENTITY(1,1) Primary Key,
ProjID	   INT NOT NULL,
TaskID	   INT NOT NULL,
Subject	   VARCHAR(100) NOT NULL,
HrmID	   INT NOT NULL,
BeginDate  VARCHAR(10) NOT NULL,
EndDate	   VARCHAR(10) NOT NULL,
WorkDay	   DECIMAL  NOT NULL,
FixedCost  DECIMAL NOT NULL,
Finish	   TINYINT NOT NULL,
ParentID   INT NOT NULL,
Prefinish  VARCHAR(4000) NULL ,
IsLandMark Char(1) NOT NULL,
ModifyDate VARCHAR(10) NOT NULL,
ModifyTime VARCHAR(8) NOT NULL,
ModifyBy   INT NOT NULL,
Status	   TINYINT NOT NULL DEFAULT 0,
OperationType	TINYINT NOT NULL,
ClientIP	Varchar(20) NOT NULL
)
GO
/*增加一个字段到任务执行表*/
ALTER TABLE Prj_TaskProcess
	ADD Status TINYINT NOT NULL DEFAULT 0
GO

/*存储过程：Prj_TaskModifyLog_Insert*/
CREATE PROCEDURE Prj_TaskModifyLog_Insert 
  (
@ProjID_1	   INT ,
@TaskID_1	   INT ,
@Subject_1	   VARCHAR(100),
@HrmID_1	   INT ,
@BeginDate_1  VARCHAR(10) ,
@EndDate_1	   VARCHAR(10) ,
@WorkDay_1	   DECIMAL  ,
@FixedCost_1  DECIMAL ,
@Finish_1	   TINYINT ,
@ParentID_1 INT,
@Prefinish_1  VARCHAR(4000)  ,
@IsLandMark_1 Char(1) ,
@ModifyDate_1 VARCHAR(10) ,
@ModifyTime_1 VARCHAR(8) ,
@ModifyBy_1   INT ,
@Status_1	   TINYINT ,
@OperationType_1	TINYINT,
@ClientIP_1	Varchar(20),
@flag integer output, @msg varchar(80) output  ) 
AS 

INSERT INTO Prj_TaskModifyLog (
ProjID	   ,
TaskID	   ,
Subject	   ,
HrmID	   ,
BeginDate  ,
EndDate	   ,
WorkDay	   ,
FixedCost  ,
Finish	   ,
ParentID   ,
Prefinish  ,
IsLandMark ,
ModifyDate ,
ModifyTime ,
ModifyBy   ,
Status	   ,
OperationType	,
ClientIP
)
VALUES(
@ProjID_1	   ,
@TaskID_1	   ,
@Subject_1	   ,
@HrmID_1	   ,
@BeginDate_1       ,
@EndDate_1	   ,
@WorkDay_1	   ,
@FixedCost_1       ,
@Finish_1	   ,
@ParentID_1        ,
@Prefinish_1  ,
@IsLandMark_1 ,
@ModifyDate_1 ,
@ModifyTime_1 ,
@ModifyBy_1   ,
@Status_1	   ,
@OperationType_1	,
@ClientIP_1
)

set @flag = 1 set @msg = 'OK!'

GO

/*Add Sql script*/
Alter Table Bill_Meeting
    Add approveby int not null default 0,
        approvedate varchar(10) null 
GO