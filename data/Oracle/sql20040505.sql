/*标签Labels*/
INSERT INTO HtmlLabelIndex values(17159,'项目审批单据') 
/
INSERT INTO HtmlLabelInfo VALUES(17159,'项目审批单据',7) 
/
INSERT INTO Prj_ProjectStatus (fullname,description) values ('审批退回','审批退回')
/ 
/*项目审批单据*/
CREATE TABLE Bill_ApproveProj ( 
    id integer,
    ApproveID integer,
    Manager integer,
    requestid integer) 
/
create sequence Bill_ApproveProj_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           
create or replace trigger Bill_ApproveProj_Tri
before insert on Bill_ApproveProj
for each row
begin
select Bill_ApproveProj_id.nextval into :new.id from dual;
end;
/
INSERT INTO workflow_bill 
( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) 
VALUES(74,17159,'Bill_ApproveProj','AddApproveProj.jsp','ManageApproveProj.jsp','ViewApproveProj.jsp','','','BillApproveProjOperation.jsp') 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (74,'Manager',16573,'integer',3,1,1,0) 
/


create or replace  PROCEDURE Prj_ProjectType_SelectAll 
( flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) AS 
begin
open thecursor for
SELECT type.* ,base.workflowname FROM  Prj_ProjectType type, 
Workflow_base base WHERE type.wfid = base.id(+);
end;
/

create or replace  PROCEDURE Prj_ProjectType_SelectByID 
(id_1	integer, 
flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor) AS 
 begin
open thecursor for
SELECT type.*,base.workflowname FROM Prj_ProjectType type 
, Workflow_base base WHERE type.wfid = base.id(+) and type.id = id_1;
end;
/

/*会议*/
/*标签*/
INSERT INTO HtmlLabelIndex values(17219,'会议审批单') 
/
INSERT INTO HtmlLabelInfo VALUES(17219,'会议审批单',7) 
/
/*会议类型浏览筐*/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 89,2104,'integer','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingTypeBrowser.jsp','Meeting_Type','name','id','/meeting/Maint/ListMeetingType.jsp?id=')
/

/*修改会议浏览筐的链接地址*/
UPDATE workflow_browserurl
SET LinkUrl = '/meeting/data/ViewMeeting.jsp?isrequest=1&meetingid='
WHERE ID = 28

/
/*会议审批单据*/
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(85,17219,'Bill_Meeting','AddBillMeeting.jsp','ManageBillMeeting.jsp','ViewBillMeeting.jsp','','','BillMeetingOperation.jsp') 
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'MeetingType',2104,'integer',3,89,0,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'MeetingName',2151,'varchar2(255)',1,1,1,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Caller',2152,'integer',3,1,2,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Contacter',572,'integer',3,1,3,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'BeginDate',740,'varchar2(10)',3,2,4,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'BeginTime',742,'varchar2(8)',3,19,5,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'EndDate',741,'varchar2(10)',3,2,6,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'EndTime',743,'varchar2(8)',3,19,7,0)
/ 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'Address',2105,'integer',3,87,8,0) 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (85,'ApproveID',926,'integer',3,28,9,0)
/
CREATE TABLE Bill_Meeting ( 
    id integer,
    ApproveID integer,
    MeetingType integer,
    MeetingName varchar2(255),
    Caller integer,
    Contacter integer,
    BeginDate varchar2(10),
    BeginTime varchar2(8),
    EndDate varchar2(10),
    EndTime varchar2(8),
    Address integer,
    requestid integer) 
/
create sequence Bill_Meeting_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           
create or replace trigger Bill_Meeting_Tri
before insert on Bill_Meeting
for each row
begin
select Bill_Meeting_id.nextval into :new.id from dual;
end;
/
/*修改会议表，增加两列*/
Alter table Meeting 
	add meetingstatus integer  default 0 not null
/
Alter table Meeting 
add requestid integer default 0 not null 
/

/*修改项目表，添加requestid列*/
Alter Table  Prj_ProjectInfo
	 Add requestid integer default 0 not null
/
/*审批任务*/

/*新增April 21,2004 任务更改历史表*/
Create TABLE Prj_TaskModifyLog  (
ID	   integer  Primary Key,
ProjID	   integer NOT NULL,
TaskID	   integer NOT NULL,
Subject	   varchar2(100) NOT NULL,
HrmID	   integer NOT NULL,
BeginDate  varchar2(10) NOT NULL,
EndDate	   varchar2(10) NOT NULL,
WorkDay	   DECIMAL  NOT NULL,
FixedCost  DECIMAL NOT NULL,
Finish	   smallint NOT NULL,
ParentID   integer NOT NULL,
Prefinish  varchar2(4000) NULL ,
IsLandMark Char(1) NOT NULL,
ModifyDate varchar2(10) NOT NULL,
ModifyTime varchar2(8) NOT NULL,
ModifyBy   integer NOT NULL,
Status	   smallint DEFAULT 0 NOT NULL ,
OperationType	smallint NOT NULL,
ClientIP	varchar2(20) NOT NULL
)
/
create sequence Prj_TaskModifyLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           
create or replace trigger Prj_TaskModifyLog_Tri
before insert on Prj_TaskModifyLog
for each row
begin
select Prj_TaskModifyLog_id.nextval into :new.id from dual;
end;
/
/*增加一个字段到任务执行表*/
ALTER TABLE Prj_TaskProcess
	ADD Status smallint DEFAULT 0 NOT NULL 
/

/*存储过程：Prj_TaskModifyLog_Insert*/
create or replace PROCEDURE Prj_TaskModifyLog_Insert
  (
ProjID_1	   integer ,
TaskID_1	   integer ,
Subject_1	   varchar2,
HrmID_1	   integer ,
BeginDate_1  varchar2 ,
EndDate_1	   varchar2 ,
WorkDay_1	   DECIMAL  ,
FixedCost_1  DECIMAL ,
Finish_1	   smallint ,
ParentID_1 integer,
Prefinish_1  varchar2  ,
IsLandMark_1 Char ,
ModifyDate_1 varchar2 ,
ModifyTime_1 varchar2,
ModifyBy_1   integer ,
Status_1	   smallint ,
OperationType_1	smallint,
ClientIP_1	varchar2,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
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
ProjID_1	   ,
TaskID_1	   ,
Subject_1	   ,
HrmID_1	   ,
BeginDate_1       ,
EndDate_1	   ,
WorkDay_1	   ,
FixedCost_1       ,
Finish_1	   ,
ParentID_1        ,
Prefinish_1  ,
IsLandMark_1 ,
ModifyDate_1 ,
ModifyTime_1 ,
ModifyBy_1   ,
Status_1	   ,
OperationType_1	,
ClientIP_1
);
end;
/

/*Add Sql script*/
Alter Table Bill_Meeting
    Add approveby integer default 0 not null
/
 Alter Table Bill_Meeting
    Add approvedate varchar2(10) null 
/