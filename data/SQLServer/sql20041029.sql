/* table */
ALTER TABLE WorkPlan ADD urgentLevel char(1) DEFAULT '1'
GO

ALTER TABLE WorkPlan ADD agentId int DEFAULT 0
GO

ALTER TABLE WorkPlan ADD deptId int NULL
GO

ALTER TABLE WorkPlan ADD subcompanyId int NULL
GO

ALTER TABLE WorkPlan ALTER COLUMN name varchar(200) NULL
GO

ALTER TABLE Prj_TaskProcess ADD realManDays decimal(6, 1) NULL
GO

ALTER TABLE Prj_TaskModifyLog ADD realManDays decimal(6, 1) NULL
GO

CREATE TABLE [WorkPlanViewLog] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[workPlanId] [int] NULL,
[viewType] [char] (1) NULL,
[userId] [int] NULL,
[userType] [char] (1) NULL,
[ipAddress] [char] (15) NULL,
[logDate] [char] (10) NULL,
[logTime] [char] (8) NULL,
PRIMARY KEY([id])
)
GO

CREATE TABLE [WorkPlanEditLog] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[workPlanId] [int] NULL,
[fieldName] [varchar] (30) NULL,
[oldValue] [varchar] (100) NULL,
[newValue] [varchar] (100) NULL,
[userId] [int] NULL,
[userType] [char] (1) NULL,
[ipAddress] [char] (15) NULL,
[logDate] [char] (10) NULL,
[logTime] [char] (8) NULL,
PRIMARY KEY([id])
)
GO

CREATE TABLE [WorkPlanExchange] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[workPlanId] [int] NULL,
[memberId] [int] NULL,
[exchangeCount] [int] DEFAULT 0,
PRIMARY KEY([id])
)
GO

CREATE TABLE [WorkPlanShare] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[workPlanId] [int] NULL,
[shareType] [char] (1) NULL,
[userId] [int] NULL,
[deptId] [int] NULL,
[roleId] [int] NULL,
[forAll] [char] (1) NULL,
[roleLevel] [char] (1) NULL,
[securityLevel] [tinyint] NULL,
[shareLevel] [char] (1) NULL,
PRIMARY KEY([id])
)
GO

CREATE TABLE [WorkPlanValuate] (
[id] [int] IDENTITY (1, 1) NOT NULL,
[workPlanId] [int] NULL,
[memberId] [int] NULL,
[createrScore] [char] (1) NULL,
[createrId] [int] NULL,
[managerScore] [char] (1) NULL,
[managerId] [int] NULL,
[valCreaterDate] [char] (10) NULL,
[valManagerDate] [char] (10) NULL,
PRIMARY KEY([id])
)
GO

CREATE TABLE [WorkPlanSetup] (
[userId] [int] NOT NULL,
[reportType] [char] (1) NOT NULL,
[recCount] [int] NULL,
PRIMARY KEY([userId], [reportType])
)
GO

CREATE TABLE [WorkPlanUpdate] (
[hasUpdated] char(1) DEFAULT '0'
)
GO

CREATE TABLE [Prj_ViewedLog] (
[projId] int NOT NULL,
[userId] int NOT NULL,
[userType] char(1) NOT NULL
PRIMARY KEY([projId], [userId], [userType])
)
GO

INSERT INTO WorkPlanUpdate (hasUpdated) VALUES ('0')
GO


/* label */
UPDATE HtmlLabelIndex SET indexdesc = '工作计划' WHERE id = 16652
GO
UPDATE HtmlLabelInfo SET labelname = '工作计划' WHERE indexid = 16652 AND languageid = 7
GO

INSERT INTO HtmlLabelIndex values(17478,'计划提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17478,'计划提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17478,'Work Plan Reminder',8) 
GO

INSERT INTO HtmlLabelIndex values(17480,'查看日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(17480,'查看日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17480,'View Log',8) 
GO

INSERT INTO HtmlLabelIndex values(17481,'更改日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(17481,'更改日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17481,'Edit Log',8) 
GO

INSERT INTO HtmlLabelIndex values(17482,'操作人') 
GO
INSERT INTO HtmlLabelInfo VALUES(17482,'操作人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17482,'Operator',8) 
GO

INSERT INTO HtmlLabelIndex values(17483,'查看类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(17483,'查看类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17483,'View Type',8) 
GO

INSERT INTO HtmlLabelIndex values(17484,'客户端地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(17484,'客户端地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17484,'Remote Address',8) 
GO

INSERT INTO HtmlLabelIndex values(17485,'修改前的值') 
GO
INSERT INTO HtmlLabelInfo VALUES(17485,'修改前的值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17485,'Old Value',8) 
GO

INSERT INTO HtmlLabelIndex values(17486,'修改后的值') 
GO
INSERT INTO HtmlLabelInfo VALUES(17486,'修改后的值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17486,'New Value',8) 
GO

INSERT INTO HtmlLabelIndex values(17487,'个人便签') 
GO
INSERT INTO HtmlLabelInfo VALUES(17487,'个人便签',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17487,'Note',8) 
GO

INSERT INTO HtmlLabelIndex values(17488,'设置记录数') 
GO
INSERT INTO HtmlLabelInfo VALUES(17488,'设置记录数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17488,'Display Record Count',8) 
GO

INSERT INTO HtmlLabelIndex values(17489,'提交人打分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17489,'提交人打分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17489,'Creater Valuate',8) 
GO

INSERT INTO HtmlLabelIndex values(17490,'上级打分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17490,'上级打分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17490,'Manager Valuate',8) 
GO

INSERT INTO HtmlLabelIndex values(17491,'每页显示记录数') 
GO
INSERT INTO HtmlLabelInfo VALUES(17491,'每页显示记录数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17491,'Display record count per page',8) 
GO

INSERT INTO HtmlLabelIndex values(17492,'我安排的计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17492,'我安排的计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17492,'I arrange the work plan',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17493,'我下属的计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17493,'我下属的计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17493,'My underling work plan',8) 
GO

INSERT INTO HtmlLabelIndex values(17494,'所有下属') 
GO
INSERT INTO HtmlLabelInfo VALUES(17494,'所有下属',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17494,'All Underlings',8) 
GO

INSERT INTO HtmlLabelIndex values(17495,'季度') 
GO
INSERT INTO HtmlLabelInfo VALUES(17495,'季度',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17495,'Quarter',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17497,'到期提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17497,'到期提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17497,'Work Plan Remind',8) 
GO

INSERT INTO HtmlLabelIndex values(17498,'便签功能') 
GO
INSERT INTO HtmlLabelInfo VALUES(17498,'便签功能',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17498,'Note Function',8) 
GO

INSERT INTO HtmlLabelIndex values(17499,'更多') 
GO
INSERT INTO HtmlLabelInfo VALUES(17499,'更多',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17499,'More',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17500,'反馈的请求') 
GO
INSERT INTO HtmlLabelInfo VALUES(17500,'反馈的请求',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17500,'Feed Back Request',8) 
GO
 
insert into ErrorMsgIndex (id,indexdesc) values (35,'该共享已存在！') 
GO
insert into ErrorMsgInfo (indexid,msgname,languageid) values (35, '该共享已存在！', 7) 
GO
insert into ErrorMsgInfo (indexid,msgname,languageid) values (35, 'This share has existed.', 8) 
GO

INSERT INTO HtmlLabelIndex values(17501,'实际工时') 
GO
INSERT INTO HtmlLabelInfo VALUES(17501,'实际工时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17501,'Real Man Days',8) 
GO

insert into HtmlNoteIndex (id,indexdesc) values (58,'确定要提交吗？') 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (58, '确定要提交吗？', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (58, 'Do you confirm to submit?', 8) 
GO

insert into HtmlNoteIndex (id,indexdesc) values (59,'打分数据需要提交吗？') 
GO

insert into HtmlNoteInfo (indexid,notename,languageid) values (59, '打分数据需要提交吗？', 7) 
GO
insert into HtmlNoteInfo (indexid,notename,languageid) values (59, 'Do the score need to submit?', 8) 
GO

INSERT INTO HtmlLabelIndex values(17503,'我的考核') 
GO
INSERT INTO HtmlLabelInfo VALUES(17503,'我的考核',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17503,'My Valuation',8) 
GO


/* stored procedure */
CREATE PROCEDURE WorkPlanViewLog_Insert (
@workPlanId_1 int, @viewType_1 char(1), @userId_1 int, @userType_1 char(1), @ipAddress_1 char(15), @logDate_1 char(10),
@logTime_1 char(8), @flag integer output , @msg varchar(80) output)
AS
INSERT INTO WorkPlanViewLog (
workPlanId, viewType, userId, userType, ipAddress, logDate, logTime) VALUES (
@workPlanId_1, @viewType_1, @userId_1, @userType_1, @ipAddress_1, @logDate_1, @logTime_1)
GO

CREATE PROCEDURE WorkPlanEditLog_Insert (
@workPlanId_1 int, @fieldName_1 varchar(30), @oldValue_1 varchar(100), @newValue_1 varchar(100),
@userId_1 int, @userType_1 char(1), @ipAddress_1 char(15), @logDate_1 char(10),
@logTime_1 char(8), @flag integer output , @msg varchar(80) output)
AS
INSERT INTO WorkPlanEditLog (
workPlanId, fieldName, oldValue, newValue, userId, userType, ipAddress, logDate, logTime) VALUES (
@workPlanId_1, @fieldName_1, @oldValue_1, @newValue_1, @userId_1, @userType_1, @ipAddress_1, @logDate_1, @logTime_1)
GO

CREATE PROCEDURE WorkPlanExchange_Insert (
@workPlanId_1 int, @memberId_1 int, @flag integer output , @msg varchar(80) output)
AS
INSERT INTO WorkPlanExchange (
workPlanId, memberId) VALUES (
@workPlanId_1, @memberId_1)
GO

CREATE PROCEDURE WorkPlanShare_Ins (
@workPlanId_1 int, @shareType_1 char(1), @userId_1 int, @deptId_1 int, @roleId_1 int, 
@forAll_1 char(1), @roleLevel_1 char(1), @securityLevel_1 tinyint, @shareLevel_1 char(1), 
@flag integer output , @msg varchar(80) output)
AS
IF EXISTS (SELECT workPlanId FROM WorkPlanShare 
WHERE workPlanId = @workPlanId_1 AND shareType = @shareType_1 AND userId = @userId_1 
AND deptId = @deptId_1 AND roleId = @roleId_1 AND forAll = @forAll_1 AND roleLevel = @roleLevel_1 
AND securityLevel = @securityLevel_1 AND shareLevel = @shareLevel_1)
BEGIN
SELECT -1 RETURN
END
ELSE
INSERT INTO WorkPlanShare (
workPlanId, shareType, userId, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel) VALUES (
@workPlanId_1, @shareType_1, @userId_1, @deptId_1, @roleId_1, @forAll_1, 
@roleLevel_1, @securityLevel_1, @shareLevel_1)
GO

CREATE PROCEDURE WorkPlanValuate_ValCreater (
@workPlanId_1 int, @memberId_1 int, @createrScore_1 char(1), @createrId_1 int,
@valCreaterDate_1 char(10), @flag integer output , @msg varchar(80) output)
AS
INSERT INTO WorkPlanValuate (
workPlanId, memberId, createrScore, createrId, valCreaterDate) VALUES (
@workPlanId_1, @memberId_1, @createrScore_1, @createrId_1, @valCreaterDate_1)
GO

CREATE PROCEDURE WorkPlanValuate_ValManager (
@workPlanId_1 int, @memberId_1 int, @managerScore_1 char(1), @managerId_1 int,
@valManagerDate_1 char(10), @flag integer output , @msg varchar(80) output)
AS
UPDATE WorkPlanValuate SET managerScore = @managerScore_1, managerId = @managerId_1, 
valManagerDate = @valManagerDate_1 WHERE workPlanId = @workPlanId_1 AND memberId = @memberId_1
GO

CREATE PROCEDURE WorkPlanSetup_SetRecCount (
@userId_1 int, @reportType_1 char(1), @recCount_1 int, @flag integer output , @msg varchar(80) output)
AS
IF EXISTS (SELECT userId FROM WorkPlanSetup WHERE userId = @userId_1 AND reportType = @reportType_1)
UPDATE WorkPlanSetup SET recCount = @recCount_1
ELSE
INSERT INTO WorkPlanSetup (userId, reportType, recCount) VALUES (
@userId_1, @reportType_1, @recCount_1)
GO

CREATE PROCEDURE Prj_ViewedLog_Insert (
@projId_1 int, @userId_1 int, @userType_1 char(1), @flag integer output , @msg varchar(80) output)
AS
IF EXISTS (SELECT projId FROM Prj_ViewedLog 
WHERE projId = @projId_1 AND userId = @userId_1 AND userType = @userType_1)
RETURN
ELSE
INSERT INTO Prj_ViewedLog (projId, userId, userType) VALUES (
@projId_1, @userId_1, @userType_1)
GO

ALTER PROCEDURE WorkPlanShare_Insert (
	@workid_1 [int]  ,
	@userid_1 [int]   ,	
	@usertype_1 [int]   ,
	@sharelevel_1 [int]   ,
	@flag integer output,
	@msg varchar(80) output)

AS 
/*
IF EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 
AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = @sharelevel_1)
RETURN
IF (@sharelevel_1 = 2 AND EXISTS(SELECT workid FROM WorkPlanShareDetail WHERE workid = @workid_1 
AND userid = @userid_1 AND usertype = @usertype_1 AND sharelevel = 1))
BEGIN
UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workid_1 AND userid = @userid_1 AND usertype = @usertype_1
RETURN
END
*/
INSERT INTO [WorkPlanShareDetail] 
	(workid , userid , usertype , sharelevel)
	VALUES
	(@workid_1 , @userid_1 , @usertype_1 , @sharelevel_1)

GO

ALTER PROCEDURE WorkPlan_Insert (
	@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@description_1  [text]    ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,	
	@status_1  [char] (1)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@createrid_1 [int]   ,
	@createdate_1 [char] (10)   ,
	@createtime_1 [char] (8) ,
	@deleted_1 [char] (1)   ,
	@taskid_1 [varchar] (100),
	@urgentLevel_1 [char] (1),
	@agentId_1 [int],
	@flag integer output,
	@msg varchar(80) output)
AS INSERT INTO [WorkPlan] (
	type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted,
	taskid,
	urgentLevel,
	agentId
) VALUES (
	@type_n_1 ,
	@name_1  ,
	@resourceid_1 ,
	@begindate_1 ,
	@begintime_1 ,
	@enddate_1 ,
	@endtime_1  ,
	@description_1 ,
	@requestid_1  ,
	@projectid_1 ,
	@crmid_1  ,
	@docid_1  ,
	@meetingid_1 ,
	@status_1  ,
	@isremind_1  ,
	@waketime_1  ,	
	@createrid_1  ,
	@createdate_1  ,
	@createtime_1 ,
	@deleted_1,
	@taskid_1,
	@urgentLevel_1,
	@agentId_1
)

DECLARE @m_id int
DECLARE @m_deptId int
DECLARE @m_subcoId int

SELECT @m_id = MAX(id) FROM WorkPlan
SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id
SELECT @m_id AS id
GO

ALTER PROCEDURE WorkPlan_Update (
	@id_1 	[int],
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@description_1  [text]    ,
	@requestid_1  [varchar] (100)   ,
	@projectid_1  [varchar] (100)   ,
	@crmid_1  [varchar] (100)   ,
	@docid_1  [varchar] (100)   ,
	@meetingid_1  [varchar] (100)   ,	
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,
	@taskid_1 [varchar] (100),
	@urgentLevel_1 [char] (1),
	@agentId_1 [int],
	@flag integer output,
	@msg varchar(80) output)
AS UPDATE WorkPlan SET
	name = @name_1,
	resourceid = @resourceid_1,
	begindate = @begindate_1,
	begintime = @begintime_1,
	enddate = @enddate_1,
	endtime  = @endtime_1,
	description = @description_1,
	requestid  = @requestid_1,
	projectid = @projectid_1,
	crmid  = @crmid_1,
	docid  = @docid_1,
	meetingid = @meetingid_1,
	isremind  = @isremind_1,
	waketime  = @waketime_1,	
	taskid = @taskid_1,
	urgentLevel = @urgentLevel_1,
	agentId = @agentId_1
WHERE id = @id_1
GO


CREATE PROCEDURE CRM_ContactLog_WorkPlan (
@flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_logid int
DECLARE @m_customerid int
DECLARE @m_resourceid int
DECLARE @m_subject varchar(100)
DECLARE @m_contactdate char(10)
DECLARE @m_contacttime char(8)
DECLARE @m_enddate char(10)
DECLARE @m_endtime char(10)
DECLARE @m_contactinfo varchar(4000)
DECLARE @m_documentid int
DECLARE @m_submitdate char(10)
DECLARE @m_submittime char(8)
DECLARE @m_isfinished tinyint
DECLARE @m_isprocessed tinyint
DECLARE @m_agentid int
DECLARE @m_status char(1)
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE @m_deptId int
DECLARE @m_subcoId int

DECLARE all_cursor CURSOR FOR
SELECT id, customerid, resourceid, subject, contactdate, 
contacttime, enddate, endtime, contactinfo, documentid, 
submitdate, submittime, isfinished, isprocessed, agentid FROM CRM_ContactLog
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_logid, @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime, @m_enddate,
@m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_isfinished, @m_isprocessed, @m_agentid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
IF (@m_subject <> 'Create')
BEGIN

IF (@m_isfinished = 0)
SET @m_status = '0'
ELSE IF (@m_isprocessed = 0)
SET @m_status = '1'
ELSE
SET @m_status = '2'

INSERT INTO WorkPlan (
type_n, urgentLevel, crmid, resourceid, name, begindate, begintime, enddate, endtime, description, docid, createdate, createtime,
agentId, status, createrid) VALUES ('3', '1', @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime,
@m_enddate, @m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_agentid, @m_status, @m_resourceid)
SELECT @m_workid = MAX(id) FROM WorkPlan

IF EXISTS(SELECT id FROM CRM_SellChance WHERE comefromid = @m_logid) 
UPDATE CRM_SellChance SET comefromid = @m_workid WHERE comefromid = @m_logid

SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @m_resourceid
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_workid

INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) 
SELECT @m_workid, userid, usertype , 0 FROM CrmShareDetail WHERE crmid = @m_customerid
END

FETCH NEXT FROM all_cursor INTO @m_logid, @m_customerid, @m_resourceid, @m_subject, @m_contactdate, @m_contacttime, @m_enddate,
@m_endtime, @m_contactinfo, @m_documentid, @m_submitdate, @m_submittime, @m_isfinished, @m_isprocessed, @m_agentid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

CREATE PROCEDURE CRM_Share_WorkPlan (
@crmId_1 int, @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmId_1)
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
DECLARE m_cursor CURSOR FOR
SELECT userid, usertype FROM CrmShareDetail WHERE crmid = @crmId_1
OPEN m_cursor
FETCH NEXT FROM m_cursor INTO @m_userid, @m_usertype
WHILE (@@FETCH_STATUS = 0)
BEGIN
IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @m_workid 
AND userid = @m_userid AND usertype = @m_usertype)
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
@m_workid, @m_userid, @m_usertype, 0)
FETCH NEXT FROM m_cursor INTO @m_userid, @m_usertype
END
CLOSE m_cursor 
DEALLOCATE m_cursor
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

ALTER PROCEDURE Prj_TaskProcess_Insert 
 (@prjid 	int,
 @taskid 	int, 
 @wbscoding 	varchar(20),
 @subject 	varchar(80) , 
 @version 	tinyint, 
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @workday decimal (10,1),
 @content 	varchar(255),
 @fixedcost decimal (10,2),
 @parentid int, 
 @parentids varchar (255), 
 @parenthrmids varchar (255), 
 @level_n tinyint,
 @hrmid int,
 @prefinish_1 varchar(4000),
 @realManDays decimal (6,1), 
 @flag integer output, @msg varchar(80) output  ) 
AS 
declare @dsporder_9 int, @current_maxid int

select @current_maxid = max(dsporder) from Prj_TaskProcess 
where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
if @current_maxid is null set @current_maxid = 0 
set @dsporder_9 = @current_maxid + 1

INSERT INTO Prj_TaskProcess 
( prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish,
dsporder,
realManDays
)  
VALUES 
( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate,
@workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9, @realManDays) 
Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
select @id = max(id) from Prj_TaskProcess 
set @maxid = convert(varchar(10), @id) + ','
set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
set @flag = 1 set @msg = 'OK!'
GO

ALTER PROCEDURE Prj_TaskProcess_Update 
 (@id	int,
 @wbscoding varchar(20),
 @subject 	varchar(80) ,
 @begindate 	varchar(10),
 @enddate 	varchar(10), 
 @workday decimal (10,1), 
 @content 	varchar(255),
 @fixedcost decimal (10,2), 
 @hrmid int, 
 @oldhrmid int, 
 @finish tinyint, 
 @taskconfirm char(1),
 @islandmark char(1),
 @prefinish_1 varchar(4000),
 @realManDays decimal (6,1),
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
UPDATE Prj_TaskProcess  
SET  
wbscoding = @wbscoding, 
subject = @subject ,
begindate = @begindate,
enddate = @enddate 	, 
workday = @workday, 
content = @content,
fixedcost = @fixedcost,
hrmid = @hrmid, 
finish = @finish ,
taskconfirm = @taskconfirm,
islandmark = @islandmark,
prefinish = @prefinish_1,
realManDays = @realManDays
WHERE ( id	 = @id) 
if @hrmid<>@oldhrmid
begin
Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
UPDATE Prj_TaskProcess set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO

CREATE PROCEDURE WorkPlan_SetAllDeptSubco
AS
DECLARE @m_id int
DECLARE @m_createrId int
DECLARE @m_deptId int
DECLARE @m_subcoId int
DECLARE all_cursor CURSOR FOR
SELECT id, createrid FROM WorkPlan 
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_id, @m_createrId
WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @m_createrId
        UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id
	FETCH NEXT FROM all_cursor INTO @m_id , @m_createrId
    END 
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

EXEC WorkPlan_SetAllDeptSubco
DROP PROCEDURE WorkPlan_SetAllDeptSubco 
GO

ALTER PROCEDURE Prj_TaskModifyLog_Insert 
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
@realManDays decimal (6,1),
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
ClientIP,
realManDays
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
@ClientIP_1,
@realManDays
)

set @flag = 1 set @msg = 'OK!'
GO

ALTER TRIGGER Tri_Update_HrmRoleMembersShare ON HrmRoleMembers WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS
Declare @roleid_1 int,
        @resourceid_1 int,
        @oldrolelevel_1 char(1),
        @oldroleid_1 int,
        @oldresourceid_1 int,
        @rolelevel_1 char(1),
        @docid_1	 int,
	    @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,
        @sharelevel_1  int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @seclevel_1	 int,
        @countrec      int,
        @countdelete   int,
        @countinsert   int,
        @contractid_1	 int, /*2003-11-06杨国生*/
        @contractroleid_1 int ,   /*2003-11-06杨国生*/
        @sharelevel_Temp int,    /*2003-11-06杨国生*/
	@workPlanId_1 int	/* added by lupeng 2004-07-22 */

        
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */

select @countdelete = count(*) from deleted
select @countinsert = count(*) from inserted

select @oldrolelevel_1 = rolelevel, @oldroleid_1 = roleid, @oldresourceid_1 = resourceid from deleted

if @countinsert > 0 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from inserted
else 
    select @roleid_1 = roleid , @resourceid_1 = resourceid, @rolelevel_1 = rolelevel from deleted

/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (@countdelete > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @oldresourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_DUserP_RoleChange @oldresourceid_1, @oldroleid_1, @oldrolelevel_1, @seclevel_1
    end
end
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (@countinsert > 0) begin
    select @seclevel_1 = seclevel from hrmresource where id = @resourceid_1
    if @seclevel_1 is not null begin
        execute Doc_DirAcl_GUserP_RoleChange @resourceid_1, @roleid_1, @rolelevel_1, @seclevel_1
    end
end

if ( @countinsert >0 and ( @countdelete = 0 or @rolelevel_1  > @oldrolelevel_1 ) )     
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    if @rolelevel_1 = '2'       /* 新的角色级别为总部级 */
    begin 

	/* ------- DOC 部分 ------- */

        declare sharedocid_cursor cursor for
        select distinct docid , sharelevel from DocShare where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor

	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)		
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid=@crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor


	/* ------- PROJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor


	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = @roleid_1 and rolelevel <= @rolelevel_1 and seclevel <= @seclevel_1 
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor

     
        /* ------- 客户合同部分 总部 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and t2.rolelevel=2 ;
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	   

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = @roleid_1 AND roleLevel <= @rolelevel_1 AND securityLevel <= @seclevel_1 
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 /* end */


    end
    else if @rolelevel_1 = '1'          /* 新的角色级别为分部级 */
    begin

	/* ------- DOC 部分 ------- */
        declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 , hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor


	/* ------- CRM 部分 ------- */
       declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */
            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department=t4.id and t4.subcompanyid1= @subcompanyid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid=@prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid=@cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor



        /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	   

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.subcompanyId = @subcompanyid_1
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 /* end */


    end
    else if @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */
    begin

        /* ------- DOC 部分 ------- */

	declare sharedocid_cursor cursor for
        select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 where t1.id=t2.docid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.docdepartmentid= @departmentid_1
        open sharedocid_cursor 
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update docsharedetail set sharelevel = 2 where docid=@docid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
        end 
        close sharedocid_cursor deallocate sharedocid_cursor
	
	/* ------- CRM 部分 ------- */

	declare sharecrmid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department = @departmentid_1
        open sharecrmid_cursor 
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CrmShareDetail values(@crmid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CrmShareDetail set sharelevel = 2 where crmid = @crmid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
		IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
		FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	   /* end */

            fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
        end 
        close sharecrmid_cursor deallocate sharecrmid_cursor

	/* ------- PRJ 部分 ------- */

	declare shareprjid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.department= @departmentid_1
        open shareprjid_cursor 
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into PrjShareDetail values(@prjid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update PrjShareDetail set sharelevel = 2 where prjid = @prjid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
        end 
        close shareprjid_cursor deallocate shareprjid_cursor

	/* ------- CPT 部分 ------- */

	declare sharecptid_cursor cursor for
        select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = @roleid_1 and t2.rolelevel <= @rolelevel_1 and t2.seclevel <= @seclevel_1 and t1.departmentid= @departmentid_1
        open sharecptid_cursor 
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  
            if @countrec = 0  
            begin
                insert into CptShareDetail values(@cptid_1, @resourceid_1, 1, @sharelevel_1)
            end
            else if @sharelevel_1 = 2  
            begin
                update CptShareDetail set sharelevel = 2 where cptid = @cptid_1 and userid = @resourceid_1 and usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
            end
            fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
        end 
        close sharecptid_cursor deallocate sharecptid_cursor


       /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
        declare roleids_cursor cursor for
        select roleid from SystemRightRoles where rightid = 396 /*396为客户合同管理权限*/
        open roleids_cursor 
        fetch next from roleids_cursor into @contractroleid_1
        while @@fetch_status=0
        begin 
            declare rolecontractid_cursor cursor for
            select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=0 and t1.department=@departmentid_1 );
            open rolecontractid_cursor 
            fetch next from rolecontractid_cursor into @contractid_1
            while @@fetch_status=0
            begin 
               select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                if @countrec = 0  
                begin
                    insert into ContractShareDetail values(@contractid_1, @resourceid_1, 1, 2)
                end
                else   
                begin
                    select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                    if @sharelevel_1 = 1
                    begin
                         update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                    end 
                end
                fetch next from rolecontractid_cursor into @contractid_1
            end
            close rolecontractid_cursor deallocate rolecontractid_cursor

            fetch next from roleids_cursor into @contractroleid_1
         end
         close roleids_cursor deallocate roleids_cursor	          

	 /* for work plan */ 
	 /* added by lupeng 2004-07-22 */
	 DECLARE sharewp_cursor CURSOR FOR
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = @roleid_1 AND t2.roleLevel <= @rolelevel_1 AND t2.securityLevel <= @seclevel_1 AND t1.deptId = @departmentid_1
         OPEN sharewp_cursor 
         FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         WHILE (@@FETCH_STATUS = 0)
         BEGIN 
	     SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  
             IF (@countrec = 0)
             BEGIN
                 INSERT INTO WorkPlanShareDetail VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
             END
             ELSE IF (@sharelevel_1 = 2)
             BEGIN
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = @workPlanId_1 AND userid = @resourceid_1 AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */   
             END
             FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
         END 
         CLOSE sharewp_cursor 
	 DEALLOCATE sharewp_cursor
	 /* end */

    end
end
else if ( @countdelete > 0 and ( @countinsert = 0 or @rolelevel_1  < @oldrolelevel_1 ) ) /* 当为删除或者级别降低 */
begin
    select @departmentid_1 = departmentid , @subcompanyid_1 = subcompanyid1 , @seclevel_1 = seclevel 
    from hrmresource where id = @resourceid_1 
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1

    /* delete the work plan share info of this user */
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1


    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid = @departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department = @departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)

	/* added by lupeng 2004-07-22 for customer contact work plan */	
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 	    
	    IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END	    
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
	/* end */

        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
    declare inuserprjid_cursor cursor for
    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =@resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' 

    
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1 
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1) /*2004-8-3 路碰 -- 角色改变时，资产的权限共享不起作用。*/
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor



     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluecontract  table(contractid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecontract 中 */

    /* 自己下级的客户合同 3 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 3)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户合同 2 */
    declare contractid_cursor cursor for
    select id from CRM_Contract where manager = @resourceid_1 
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 2)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor



    /* 作为客户合同管理员能看到的 */
    declare roleids_cursor cursor for
    select roleid from SystemRightRoles where rightid = 396
    open roleids_cursor 
    fetch next from roleids_cursor into @contractroleid_1
    while @@fetch_status=0
    begin 

       declare rolecontractid_cursor cursor for
       select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1 ) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ));
       
        open rolecontractid_cursor 
        fetch next from rolecontractid_cursor into @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
            if @countrec = 0  
            begin
                insert into @temptablevaluecontract values(@contractid_1, 2)
            end
            else
            begin
                select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                if @sharelevel_1 = 1
                begin
                     update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                end 
            end
            fetch next from rolecontractid_cursor into @contractid_1
        end
        close rolecontractid_cursor deallocate rolecontractid_cursor
        
     fetch next from roleids_cursor into @contractroleid_1
     end
     close roleids_cursor deallocate roleids_cursor	 


    /* 由客户合同的共享获得的权利 1 2 */
    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor



    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor


    /* 自己下级的客户合同  (客户经理及经理线)*/
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where ( t1.manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and (t2.crmId = t1.id)
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户 (客户经理及经理线) */
    declare contractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where (t1.manager = @resourceid_1 ) and (t2.crmId = t1.id)
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor


    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcontractid_cursor cursor for
    select * from @temptablevaluecontract
    open allcontractid_cursor 
    fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    end
    close allcontractid_cursor deallocate allcontractid_cursor

    /* for work plan */ 
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* define a temporary table */
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    DECLARE creater_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE createrid = @resourceid_1 
    OPEN creater_cursor 
    FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
        FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    END
    CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* b. the creater of the work plan is my underling */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)  INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     


    /* c. in the work plan share info */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= @seclevel_1) OR (userId = @resourceid_1) OR (deptId = @departmentid_1 AND securityLevel <= @seclevel_1))
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = @resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= @seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = @departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = @subcompanyid_1) OR (t3.rolelevel = 2)) 
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0 )
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    /* write the temporary table data to the share detail table */
    DECLARE allwp_cursor CURSOR FOR
    SELECT * FROM @TmpTableValueWP
    OPEN allwp_cursor 
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
        FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    END
    CLOSE allwp_cursor 
    DEALLOCATE allwp_cursor
    /* end */


end        /* 结束角色删除或者级别降低的处理 */
go






/* 修改hrmresource的trigger */
alter TRIGGER Tri_Update_HrmresourceShare ON Hrmresource WITH ENCRYPTION
FOR UPDATE
AS
Declare @resourceid_1 int,
        @subresourceid_1 int,
        @supresourceid_1 int,
        @olddepartmentid_1 int,
        @departmentid_1 int,
	    @subcompanyid_1 int,
        @oldseclevel_1	 int,
	    @seclevel_1	 int,
        @docid_1	 int,
        @crmid_1	 int,
	    @prjid_1	 int,
	    @cptid_1	 int,        
        @sharelevel_1  int,
        @countrec      int,
        @countdelete   int,
        @oldmanagerstr_1    varchar(200),
        @managerstr_1    varchar(200) ,
        @contractid_1	 int, /*2003-11-06杨国生*/
        @contractroleid_1 int ,   /*2003-11-06杨国生*/
        @sharelevel_Temp int,    /*2003-11-06杨国生*/
	@workPlanId_1 int	/* added by lupeng 2004-07-22 */
       


/* 从刚修改的行中查找修改的resourceid 等 */
select @olddepartmentid_1 = departmentid, @oldseclevel_1 = seclevel , 
       @oldmanagerstr_1 = managerstr from deleted
select @resourceid_1 = id , @departmentid_1 = departmentid, @subcompanyid_1 = subcompanyid1 ,  
       @seclevel_1 = seclevel , @managerstr_1 = managerstr from inserted

/* 如果部门和安全级别信息被修改 */
if ( @departmentid_1 <>@olddepartmentid_1 or  @seclevel_1 <> @oldseclevel_1 or @oldseclevel_1 is null )     
begin
    if @departmentid_1 is null   set @departmentid_1 = 0
    if @subcompanyid_1 is null   set @subcompanyid_1 = 0

    /* 修改目录许可表 */
    if ((@olddepartmentid_1 is not null) and (@oldseclevel_1 is not null)) begin
        execute Doc_DirAcl_DUserP_BasicChange @resourceid_1, @olddepartmentid_1, @oldseclevel_1
    end
    if ((@departmentid_1 is not null) and (@seclevel_1 is not null)) begin
        execute Doc_DirAcl_GUserP_BasicChange @resourceid_1, @departmentid_1, @seclevel_1
    end

    /* 该人新建文档目录的列表 */
    exec DocUserCategory_InsertByUser @resourceid_1,'0','',''
    
    /* DOC 部分*/

    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = @resourceid_1 and usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevalue  table(docid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    declare docid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid = @resourceid_1 or ownerid = @resourceid_1 ) and usertype= '1'
    open docid_cursor 
    fetch next from docid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalue values(@docid_1, 2)
        fetch next from docid_cursor into @docid_1
    end
    close docid_cursor deallocate docid_cursor


    /* 自己下级的文档 */
    /* 查找下级 */
    declare @managerstr_11 varchar(200) 
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subdocid_cursor cursor for
    select distinct id from DocDetail where ( doccreaterid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) or ownerid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and usertype= '1'
    open subdocid_cursor 
    fetch next from subdocid_cursor into @docid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1
        if @countrec = 0  insert into @temptablevalue values(@docid_1, 1)
        fetch next from subdocid_cursor into @docid_1
    end
    close subdocid_cursor deallocate subdocid_cursor
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    declare sharedocid_cursor cursor for
    select distinct docid , sharelevel from DocShare  where  (foralluser=1 and seclevel<= @seclevel_1 )  or ( userid= @resourceid_1 ) or (departmentid= @departmentid_1 and seclevel<= @seclevel_1 )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor

    declare sharedocid_cursor cursor for
    select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.docid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.docdepartmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharedocid_cursor 
    fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(docid) from @temptablevalue where docid = @docid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalue values(@docid_1, @sharelevel_1)
        end
        else if @sharelevel_1 = 2  
        begin
            update @temptablevalue set sharelevel = 2 where docid=@docid_1 /* 共享是可以编辑, 则都修改原有记录    */   
        end
        fetch next from sharedocid_cursor into @docid_1 , @sharelevel_1
    end 
    close sharedocid_cursor deallocate sharedocid_cursor



    /* 将临时表中的数据写入共享表 */
    declare alldocid_cursor cursor for
    select * from @temptablevalue
    open alldocid_cursor 
    fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into docsharedetail values(@docid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from alldocid_cursor into @docid_1 , @sharelevel_1
    end
    close alldocid_cursor deallocate alldocid_cursor


    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1
    
    /* delete the work plan share info of this user */
    DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1

    /* 定义临时表变量 */
    Declare @temptablevaluecrm  table(crmid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    declare crmid_cursor cursor for
    select id from CRM_CustomerInfo where manager = @resourceid_1 
    open crmid_cursor 
    fetch next from crmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecrm values(@crmid_1, 2)
        fetch next from crmid_cursor into @crmid_1
    end
    close crmid_cursor deallocate crmid_cursor


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcrmid_cursor cursor for
    select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcrmid_cursor 
    fetch next from subcrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 3)
        fetch next from subcrmid_cursor into @crmid_1
    end
    close subcrmid_cursor deallocate subcrmid_cursor
 
    /* 作为crm管理员能看到的客户 */
    declare rolecrmid_cursor cursor for
   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open rolecrmid_cursor 
    fetch next from rolecrmid_cursor into @crmid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1
        if @countrec = 0  insert into @temptablevaluecrm values(@crmid_1, 4)
        fetch next from rolecrmid_cursor into @crmid_1
    end
    close rolecrmid_cursor deallocate rolecrmid_cursor	 


    /* 由客户的共享获得的权利 1 2 */
    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor



    declare sharecrmid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecrmid_cursor 
    fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(crmid) from @temptablevaluecrm where crmid = @crmid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecrm values(@crmid_1, @sharelevel_1)
        end
        fetch next from sharecrmid_cursor into @crmid_1 , @sharelevel_1
    end 
    close sharecrmid_cursor deallocate sharecrmid_cursor


    /* 将临时表中的数据写入共享表 */
    declare allcrmid_cursor cursor for
    select * from @temptablevaluecrm
    open allcrmid_cursor 
    fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)

	/* added by lupeng 2004-07-22 for customer contact work plan */	
        DECLARE ccwp_cursor CURSOR FOR
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
        OPEN ccwp_cursor 
        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 	    
	    IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
        END	    
        CLOSE ccwp_cursor 
        DEALLOCATE ccwp_cursor
	/* end */

        fetch next from allcrmid_cursor into @crmid_1 , @sharelevel_1
    end
    close allcrmid_cursor deallocate allcrmid_cursor



    /* ------- PROJ 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluePrj  table(prjid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluePrj 中 */
    /*  自己的项目2 */
    declare prjid_cursor cursor for
    select id from Prj_ProjectInfo where manager = @resourceid_1 
    open prjid_cursor 
    fetch next from prjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluePrj values(@prjid_1, 2)
        fetch next from prjid_cursor into @prjid_1
    end
    close prjid_cursor deallocate prjid_cursor


    /* 自己下级的项目3 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subprjid_cursor cursor for
    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subprjid_cursor 
    fetch next from subprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 3)
        fetch next from subprjid_cursor into @prjid_1
    end
    close subprjid_cursor deallocate subprjid_cursor
 
    /* 作为项目管理员能看到的项目4 */
    declare roleprjid_cursor cursor for
   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= @resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ))
    open roleprjid_cursor 
    fetch next from roleprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1
        if @countrec = 0  insert into @temptablevaluePrj values(@prjid_1, 4)
        fetch next from roleprjid_cursor into @prjid_1
    end
    close roleprjid_cursor deallocate roleprjid_cursor	 


    /* 由项目的共享获得的权利 1 2 */
    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor


    declare shareprjid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open shareprjid_cursor 
    fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, @sharelevel_1)
        end
        fetch next from shareprjid_cursor into @prjid_1 , @sharelevel_1
    end 
    close shareprjid_cursor deallocate shareprjid_cursor



    /* 项目成员5 (内部用户) */
	declare @members_1 varchar(200)
	set @members_1 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 
    declare inuserprjid_cursor cursor for
    SELECT  id FROM Prj_ProjectInfo   WHERE  (','+members+','  LIKE  @members_1)  and isblock='1' 
    open inuserprjid_cursor 
    fetch next from inuserprjid_cursor into @prjid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(prjid) from @temptablevaluePrj where prjid = @prjid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluePrj values(@prjid_1, 5)
        end
        fetch next from inuserprjid_cursor into @prjid_1
    end 
    close inuserprjid_cursor deallocate inuserprjid_cursor


    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allprjid_cursor cursor for
    select * from @temptablevaluePrj
    open allprjid_cursor 
    fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allprjid_cursor into @prjid_1 , @sharelevel_1
    end
    close allprjid_cursor deallocate allprjid_cursor


    /* ------- CPT 部分 ------- */

    /* 定义临时表变量 */
    Declare @temptablevalueCpt  table(cptid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevalueCpt 中 */
    /*  自己的资产2 */
    declare cptid_cursor cursor for
    select id from CptCapital where resourceid = @resourceid_1 
    open cptid_cursor 
    fetch next from cptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevalueCpt values(@cptid_1, 2)
        fetch next from cptid_cursor into @cptid_1
    end
    close cptid_cursor deallocate cptid_cursor


    /* 自己下级的资产1 */
    /* 查找下级 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcptid_cursor cursor for
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcptid_cursor 
    fetch next from subcptid_cursor into @cptid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1
        if @countrec = 0  insert into @temptablevalueCpt values(@cptid_1, 1)
        fetch next from subcptid_cursor into @cptid_1
    end
    close subcptid_cursor deallocate subcptid_cursor
 
   
    /* 由资产的共享获得的权利 1 2 */
    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor


    declare sharecptid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= @resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= @seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= @departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= @subcompanyid_1 ) or (t3.rolelevel=2) )
    open sharecptid_cursor 
    fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(cptid) from @temptablevalueCpt where cptid = @cptid_1  
        if @countrec = 0  
        begin
            insert into @temptablevalueCpt values(@cptid_1, @sharelevel_1)
        end       
        fetch next from sharecptid_cursor into @cptid_1 , @sharelevel_1
    end 
    close sharecptid_cursor deallocate sharecptid_cursor
    


    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcptid_cursor cursor for
    select * from @temptablevalueCpt
    open allcptid_cursor 
    fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcptid_cursor into @cptid_1 , @sharelevel_1
    end
    close allcptid_cursor deallocate allcptid_cursor


     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    Declare @temptablevaluecontract  table(contractid int,sharelevel int)

    /*  将所有的信息现放到 @temptablevaluecontract 中 */

    /* 自己下级的客户合同 3 */
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) )
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 3)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户合同 2 */
    declare contractid_cursor cursor for
    select id from CRM_Contract where manager = @resourceid_1 
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 2)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor



    /* 作为客户合同管理员能看到的 */
    declare roleids_cursor cursor for
    select roleid from SystemRightRoles where rightid = 396
    open roleids_cursor 
    fetch next from roleids_cursor into @contractroleid_1
    while @@fetch_status=0
    begin 

       declare rolecontractid_cursor cursor for
       select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2  where t2.roleid=@contractroleid_1 and t2.resourceid=@resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=@departmentid_1 ) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1 ));
       
        open rolecontractid_cursor 
        fetch next from rolecontractid_cursor into @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
            if @countrec = 0  
            begin
                insert into @temptablevaluecontract values(@contractid_1, 2)
            end
            else
            begin
                select @sharelevel_1 = sharelevel from ContractShareDetail where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1
                if @sharelevel_1 = 1
                begin
                     update ContractShareDetail set sharelevel = 2 where contractid = @contractid_1 and userid = @resourceid_1 and usertype = 1  
                end 
            end
            fetch next from rolecontractid_cursor into @contractid_1
        end
        close rolecontractid_cursor deallocate rolecontractid_cursor
        
     fetch next from roleids_cursor into @contractroleid_1
     end
     close roleids_cursor deallocate roleids_cursor	 


    /* 由客户合同的共享获得的权利 1 2 */
    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=@seclevel_1)  or ( t2.userid=@resourceid_1 ) or (t2.departmentid=@departmentid_1 and t2.seclevel<=@seclevel_1)  )
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor



    declare sharecontractid_cursor cursor for
    select distinct t2.relateditemid , t2.sharelevel from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=@resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=@seclevel_1 and ( (t2.rolelevel=0  and t1.department=@departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=@subcompanyid_1) or (t3.rolelevel=2) ) 
    open sharecontractid_cursor 
    fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1  
        if @countrec = 0  
        begin
            insert into @temptablevaluecontract values(@contractid_1, @sharelevel_1)
        end
        else
        begin
            select @sharelevel_Temp = sharelevel from @temptablevaluecontract where contractid = @contractid_1
            if ((@sharelevel_Temp = 1) and (@sharelevel_1 = 2)) 
            update @temptablevaluecontract set sharelevel = @sharelevel_1 where contractid = @contractid_1
        end
        fetch next from sharecontractid_cursor into @contractid_1 , @sharelevel_1
    end 
    close sharecontractid_cursor deallocate sharecontractid_cursor


    /* 自己下级的客户合同  (客户经理及经理线)*/
     
    set @managerstr_11 = '%,' + convert(varchar(5),@resourceid_1) + ',%' 

    declare subcontractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where ( t1.manager in (select distinct id from HrmResource where ','+managerstr like @managerstr_11 ) ) and (t2.crmId = t1.id)
    open subcontractid_cursor 
    fetch next from subcontractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        select @countrec = count(contractid) from @temptablevaluecontract where contractid = @contractid_1
        if @countrec = 0  insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from subcontractid_cursor into @contractid_1
    end
    close subcontractid_cursor deallocate subcontractid_cursor

 
    /*  自己是 manager 的客户 (客户经理及经理线) */
    declare contractid_cursor cursor for
    select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2 where (t1.manager = @resourceid_1 ) and (t2.crmId = t1.id)
    open contractid_cursor 
    fetch next from contractid_cursor into @contractid_1
    while @@fetch_status=0
    begin 
        insert into @temptablevaluecontract values(@contractid_1, 1)
        fetch next from contractid_cursor into @contractid_1
    end
    close contractid_cursor deallocate contractid_cursor


    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = @resourceid_1 and usertype = 1

    /* 将临时表中的数据写入共享表 */
    declare allcontractid_cursor cursor for
    select * from @temptablevaluecontract
    open allcontractid_cursor 
    fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    while @@fetch_status=0
    begin 
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1, @resourceid_1,1,@sharelevel_1)
        fetch next from allcontractid_cursor into @contractid_1 , @sharelevel_1
    end
    close allcontractid_cursor deallocate allcontractid_cursor


    /* for work plan */ 
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* define a temporary table */
    DECLARE @TmpTableValueWP TABLE (workPlanId int, shareLevel int)
    
    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    DECLARE creater_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE createrid = @resourceid_1 
    OPEN creater_cursor 
    FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 2)
        FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    END
    CLOSE creater_cursor 
    DEALLOCATE creater_cursor

    /* b. the creater of the work plan is my underling */     
    SET @managerstr_11 = '%,' + CONVERT(varchar(5), @resourceid_1) + ',%' 
    DECLARE underling_cursor CURSOR FOR
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE ',' + MANAGERSTR LIKE @managerstr_11))
    OPEN underling_cursor 
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1
        IF (@countrec = 0)  INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, 1)
        FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    END
    CLOSE underling_cursor 
    DEALLOCATE underling_cursor     


    /* c. in the work plan share info */
    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= @seclevel_1) OR (userId = @resourceid_1) OR (deptId = @departmentid_1 AND securityLevel <= @seclevel_1))
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0)
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    DECLARE sharewp_cursor CURSOR FOR
    SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = @resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= @seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = @departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = @subcompanyid_1) OR (t3.rolelevel = 2)) 
    OPEN sharewp_cursor 
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1 , @sharelevel_1
    WHILE @@fetch_status=0
    BEGIN 
        SELECT @countrec = COUNT(workPlanId) FROM @TmpTableValueWP WHERE workPlanId = @workPlanId_1  
        IF (@countrec = 0 )
        BEGIN
            INSERT INTO @TmpTableValueWP VALUES (@workPlanId_1, @sharelevel_1)
        END
        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    END 
    CLOSE sharewp_cursor 
    DEALLOCATE sharewp_cursor

    /* write the temporary table data to the share detail table */
    DECLARE allwp_cursor CURSOR FOR
    SELECT * FROM @TmpTableValueWP
    OPEN allwp_cursor 
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE (@@FETCH_STATUS = 0)
    BEGIN 
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (@workPlanId_1, @resourceid_1, 1, @sharelevel_1)
        FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    END
    CLOSE allwp_cursor 
    DEALLOCATE allwp_cursor
    /* end */


end        /* 结束修改了部门和安全级别的情况 */
            

       
/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( @countdelete > 0 and @managerstr_1 <> @oldmanagerstr_1 )  /* 新建人力资源时候对经理字段的改变不考虑 */
begin
    if ( @managerstr_1 is not null and len(@managerstr_1) > 1 )  /* 有上级经理 */
    begin

        set @managerstr_1 = ',' + @managerstr_1

	/* ------- DOC 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, DocDetail t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and ( t2.doccreaterid = @resourceid_1 or t2.ownerid = @resourceid_1 ) and t2.usertype= '1' ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(docid) from docsharedetail where docid = @docid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into docsharedetail values(@docid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @docid_1
        end
        close supuserid_cursor deallocate supuserid_cursor
	
	/* ------- CRM 部分 ------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_CustomerInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(crmid) from CrmShareDetail where crmid = @crmid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1,@supresourceid_1,1,3)
            end

	    /* added by lupeng 2004-07-22 for customer contact work plan */	
	    DECLARE ccwp_cursor CURSOR FOR
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmid_1)
	    OPEN ccwp_cursor 
	    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    WHILE (@@FETCH_STATUS = 0)
	    BEGIN 	    
	        IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 
			AND userid = @resourceid_1 AND usertype = 1)
	        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			@workPlanId_1, @resourceid_1, 1, 1)
	        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
	    END	    
	    CLOSE ccwp_cursor 
	    DEALLOCATE ccwp_cursor
	    /* end */

            fetch next from supuserid_cursor into @supresourceid_1, @crmid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- PROJ 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, Prj_ProjectInfo t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(prjid) from PrjShareDetail where prjid = @prjid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(@prjid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @prjid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* ------- CPT 部分 ------- */
	declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CptCapital t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.resourceid = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(cptid) from CptShareDetail where cptid = @cptid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(@cptid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @cptid_1
        end
        close supuserid_cursor deallocate supuserid_cursor

        

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        declare supuserid_cursor cursor for
        select distinct t1.id , t2.id from HrmResource t1, CRM_Contract t2 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  ;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1,@supresourceid_1,1,3)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        end
        close supuserid_cursor deallocate supuserid_cursor

        declare supuserid_cursor cursor for
        select distinct t1.id , t3.id from HrmResource t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where @managerstr_1 like '%,'+convert(varchar(5),t1.id)+',%' and  t2.manager = @resourceid_1  and t2.id = t3.crmId;
        open supuserid_cursor 
        fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        while @@fetch_status=0
        begin 
            select @countrec = count(contractid) from ContractShareDetail where contractid = @contractid_1 and userid= @supresourceid_1 and usertype= 1
            if @countrec = 0  
            begin
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel) values(@contractid_1,@supresourceid_1,1,1)
            end
            fetch next from supuserid_cursor into @supresourceid_1, @contractid_1
        end
        close supuserid_cursor deallocate supuserid_cursor


	/* for work plan */ 
	/* added by lupeng 2004-07-22 */
	DECLARE supuserid_cursor CURSOR FOR
        SELECT DISTINCT t1.id, t2.id FROM HrmResource t1, WorkPlan t2 WHERE @managerstr_1 LIKE '%,' + CONVERT(varchar(5),t1.id) + ',%' AND t2.createrid = @resourceid_1
        OPEN supuserid_cursor 
        FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        WHILE (@@FETCH_STATUS = 0)
        BEGIN 
            SELECT @countrec = COUNT(workid) FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND userid = @supresourceid_1 AND usertype = 1
            IF (@countrec = 0)
            BEGIN
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(@workPlanId_1, @supresourceid_1, 1, 1)
            END
            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1, @workPlanId_1
        end
        CLOSE supuserid_cursor 
	DEALLOCATE supuserid_cursor
	/* end */


    end             /* 有上级经理判定结束 */
end   /* 修改经理的判定结束 */

go



/*当会议审批通过时加入到相关人员的工作计划中并加入相应的权限*/
ALTER TRIGGER [Tri_U_bill_WorkPlanByMeet1] ON Meeting WITH ENCRYPTION
FOR UPDATE
AS
Declare 
 	@name varchar(80),
 	@isapproved	int,
 	@begindate	char(10),
 	@begintime  char(8),
 	@enddate	char(10),
 	@endtime    char(8),
    @createdate	char(10),
 	@createtime  char(8),
 	@resourceid	int,
 	@meetingid	int,
 	@caller     int,
 	@contacter int,
    @allresource varchar(200), /*工作计划中的接受人*/
    @managerstr varchar(200),
    @managerid int,
	@tmpcount int ,
    @userid int ,
    @usertype int ,
    @sharelevel int ,
    @workplanid int ,
    @workplancount int ,
    @m_deptId int,
    @m_subcoId int,
    @all_cursor cursor,
	@detail_cursor cursor
if update(isapproved)
begin
    /* 定义临时表变量 */
    Declare @temptablevalueWork  table(workid int,userid int,usertype int,sharelevel int)

	select distinct @meetingid=id from deleted 
	
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id,name,caller,contacter,begindate,begintime,enddate,endtime,createdate,createtime from inserted 
	where isapproved=2 
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime,@createdate,@createtime
	WHILE @@FETCH_STATUS = 0
	begin
        if @enddate=''  set @enddate=@begindate

	/* get the department and subcompany info */
	/* added by lupeng 2004-07-22*/
	SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @caller
	/* end */

        /*插入工作计划表begin*/
        INSERT INTO WorkPlan  
        (type_n ,
        name  ,
        resourceid ,
        begindate ,
        begintime ,
        enddate ,
        endtime  ,
        description ,
        requestid  ,
        projectid ,
        crmid  ,
        docid  ,
        meetingid ,
        status  ,
        isremind  ,
        waketime  ,	
        createrid  ,
        createdate  ,
        createtime ,
        deleted,
	urgentLevel,
	deptId,
	subcompanyId)          
         VALUES 
        ('1' ,
        @name  ,
        @allresource ,
        @begindate ,
        @begintime ,
        @enddate ,
        @endtime  ,
        '' ,
        '0'  ,
        '0' ,
        '0'  ,
        '0'  ,
        @meetingid ,
        '0'  ,
        '1'  ,
        '0'  ,	
        @caller  ,
        @createdate  ,
        @createtime  ,
        '0',
	'1',
	@m_deptId,
	@m_subcoId)
        select top 1 @workplanid = id from WorkPlan order by id desc
        /*插入工作计划表end*/

        set @allresource = convert(varchar(5),@caller)
        if PATINDEX('%,' + convert(varchar(5),@contacter) + ',%' , ',' + @allresource + ',') = 0
        set @allresource = @allresource + ',' + convert(varchar(5),@contacter)

        /*召集人及其经理线权限--begin*/
        insert into @temptablevalueWork values(@workplanid,@caller,1,2)
        set @managerstr =''
        select @managerstr = managerstr from HrmResource where id = @caller
        set @managerstr = '%,' + @managerstr + '%'
        declare allmanagerid_cursor cursor for
        select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
        open allmanagerid_cursor 
        fetch next from allmanagerid_cursor into @managerid 
        while @@fetch_status=0
        begin 
            select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
            if @workplancount = 0
            insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
            fetch next from allmanagerid_cursor into @managerid 
        end
        close allmanagerid_cursor 
        deallocate allmanagerid_cursor

        /*召集人及其经理线权限--end*/


        /*联系人及其经理线权限--begin*/
        select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @contacter
        if @workplancount = 0
        begin
            insert into @temptablevalueWork values(@workplanid,@contacter,1,1)
            set @managerstr =''
            select @managerstr = managerstr from HrmResource where id = @contacter
            set @managerstr = '%,' + @managerstr + '%'

            declare allmanagerid_cursor cursor for
            select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
            open allmanagerid_cursor 
            fetch next from allmanagerid_cursor into @managerid 
            while @@fetch_status=0
            begin 
                select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
                if @workplancount = 0
                insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
                fetch next from allmanagerid_cursor into @managerid 
            end
            close allmanagerid_cursor 
            deallocate allmanagerid_cursor
        end

        /*联系人及其经理线权限--end*/

    	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR 
		select memberid from Meeting_Member2 where meetingid=@meetingid and membertype=1
		OPEN @detail_cursor 
		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		WHILE @@FETCH_STATUS = 0
		begin
            if PATINDEX('%,' + convert(varchar(5),@resourceid) + ',%' , ',' + @allresource + ',') = 0
    		set @allresource = @allresource + ',' + convert(varchar(5),@resourceid)  

            /*参会人及其经理线权限--begin*/
            select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @resourceid
            if @workplancount = 0
            begin
                insert into @temptablevalueWork values(@workplanid,@resourceid,1,1)
                set @managerstr =''
                select @managerstr = managerstr from HrmResource where id = @resourceid
                set @managerstr = '%,' + @managerstr + '%'

                declare allmanagerid_cursor cursor for
                select id from HrmResource where (','+CONVERT(varchar(5), id)+',') like @managerstr
                open allmanagerid_cursor 
                fetch next from allmanagerid_cursor into @managerid 
                while @@fetch_status=0
                begin 
                    select @workplancount = count(workid) from @temptablevalueWork where workid = @workplanid and userid = @managerid
                    if @workplancount = 0
                    insert into @temptablevalueWork values(@workplanid,@managerid,1,1)
                    fetch next from allmanagerid_cursor into @managerid 
                end
                close allmanagerid_cursor 
                deallocate allmanagerid_cursor
            end

            /*参会人及其经理线权限--end*/

    		FETCH NEXT FROM @detail_cursor INTO @resourceid 
		end 
		CLOSE @detail_cursor
		DEALLOCATE @detail_cursor 

        update WorkPlan set resourceid=@allresource where id = @workplanid

        /* 将临时表中的数据写入共享表 */
        declare allmeetshare_cursor cursor for
        select * from @temptablevalueWork
        open allmeetshare_cursor 
        fetch next from allmeetshare_cursor into @meetingid , @userid , @usertype , @sharelevel
        while @@fetch_status=0
        begin 
            insert into WorkPlanShareDetail values(@meetingid , @userid , @usertype , @sharelevel)
            fetch next from allmeetshare_cursor into @meetingid , @userid , @usertype , @sharelevel
        end
        close allmeetshare_cursor 
        deallocate allmeetshare_cursor

		FETCH NEXT FROM @all_cursor INTO @meetingid,@name,@caller,@contacter,@begindate,@begintime,@enddate,@endtime,@createdate,@createtime
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go


CREATE  INDEX WorkPlanShareDetail_ID ON WorkPlanShareDetail(workid,userid,usertype) 
GO

CREATE  INDEX WorkPlanExchange_ID ON WorkPlanExchange(workPlanId,memberId) 
GO


CREATE PROCEDURE WorkPlanExchange_WP_Add (
@workPlanId_1 int, @flag integer output , @msg varchar(80) output)
AS
DECLARE @m_userid int
DECLARE all_cursor CURSOR FOR
SELECT DISTINCT userid FROM WorkPlanShareDetail WHERE workid = @workPlanId_1 AND usertype = 1
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_userid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
EXEC WorkPlanExchange_Insert @workPlanId_1, @m_userid, '', ''
FETCH NEXT FROM all_cursor INTO @m_userid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

CREATE PROCEDURE WorkPlanExchange_Add (
@userId_1 int, @workPlanId_1 int, @flag integer output , @msg varchar(80) output)
AS
IF NOT EXISTS(SELECT workPlanId FROM WorkPlanExchange WHERE workPlanId = @workPlanId_1)
EXEC WorkPlanExchange_WP_Add @workPlanId_1, '', ''
IF EXISTS(SELECT workPlanId FROM WorkPlanExchange WHERE workPlanId = @workPlanId_1 AND memberId = @userId_1)
UPDATE WorkPlanExchange SET exchangeCount = exchangeCount + 1 WHERE workPlanId = @workPlanId_1 AND memberId <> @userId_1
ELSE
EXEC WorkPlanExchange_Insert @workPlanId_1, @userId_1, '', ''
GO

INSERT INTO HtmlLabelIndex values(17505,'被打分人') 
GO
INSERT INTO HtmlLabelInfo VALUES(17505,'被打分人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17505,'Checked user',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17506,'得分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17506,'得分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17506,'Score',8) 
GO
 
CREATE PROCEDURE CRM_ShareByHrm_WorkPlan (
@crmId_1 int, @userId_1 int, @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmId_1)
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @m_workid 
AND userid = @userId_1 AND usertype = 1)
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
@m_workid, @userId_1, 1, 0)
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

CREATE PROCEDURE CRM_Share_WorkPlan_Del (
@crmId_1 int, @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = CONVERT(varchar(100), @crmId_1)
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
DELETE WorkPlanShareDetail WHERE workid = @m_workid AND sharelevel = 0
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO
CREATE TABLE WorkSpaceStyle (
userId int NOT NULL,
userType char (1) NULL,
styleType char (1) DEFAULT '1'
)
GO

CREATE PROCEDURE WorkSpaceStyle_Set (
@userId_1 int, @userType_1 char(1), @styleType_1 char(1), @flag integer output , @msg varchar(80) output)
AS
IF EXISTS(SELECT userId FROM WorkSpaceStyle WHERE userId = @userId_1 AND userType = @userType_1)
UPDATE WorkSpaceStyle SET styleType = @styleType_1 WHERE userId = @userId_1 AND userType = @userType_1
ELSE
INSERT INTO WorkSpaceStyle (userId, userType, styleType) VALUES (
@userId_1, @userType_1, @styleType_1)
GO

INSERT INTO HtmlLabelIndex values(17508,'转为计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17508,'转为计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17508,'Convert to Work Plan',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17520,'查看人') 
GO
INSERT INTO HtmlLabelInfo VALUES(17520,'查看人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17520,'Hrm Resource',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17521,'创建的计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17521,'创建的计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17521,'Created Work Plan',8) 
GO

INSERT INTO HtmlLabelIndex values(17522,'接受的计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17522,'接受的计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17522,'Received Work Plan',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17523,'所有下属的计划') 
GO
INSERT INTO HtmlLabelInfo VALUES(17523,'所有下属的计划',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17523,'All Underling Work Plan',8) 
GO

INSERT INTO HtmlLabelIndex values(17524,'计划状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(17524,'计划状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17524,'Work Plan Status',8) 
GO

INSERT INTO HtmlLabelIndex values(17525,'打分状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(17525,'打分状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17525,'Valuate Status',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17526,'未打分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17526,'未打分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17526,'Unvaluated',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17527,'已打分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17527,'已打分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17527,'Valuated',8) 
GO


ALTER TABLE WorkPlan ADD createrType char(1) DEFAULT '1'
GO

ALTER TABLE Exchange_Info ADD crmIds varchar(600) NULL, projectIds varchar(600) NULL, requestIds varchar(600) NULL
GO

ALTER TABLE Exchange_Info ADD createrType char(1) DEFAULT '1'
GO

CREATE PROCEDURE Exchange_Info_Insert (
@sortId_1 int, @name_1 varchar(200), @remark_1 text, @creater_1 int,
@createDate_1 char(10), @createTime_1 char(10), @type_n_1 char(2), @docids_1 varchar(600),
@crmIds_1 varchar(600), @projectIds_1 varchar(600), @requestIds_1 varchar(600), @createrType_1 char(1),
@flag integer output , @msg varchar(80) output)
AS
INSERT INTO Exchange_Info (sortid, name, remark, creater, createDate, createTime, type_n, 
docids, crmIds, projectIds, requestIds, createrType) VALUES (@sortId_1, @name_1, @remark_1, @creater_1,
@createDate_1, @createTime_1, @type_n_1, @docids_1, @crmIds_1, @projectIds_1, @requestIds_1, @createrType_1)
GO

ALTER TABLE WorkPlanExchange ADD memberType char(1) DEFAULT '1'
GO

ALTER PROCEDURE WorkPlanExchange_Insert (
@workPlanId_1 int, @memberId_1 int, @memberType_1 char(1), @flag integer output, @msg varchar(80) output)
AS
INSERT INTO WorkPlanExchange (
workPlanId, memberId, memberType) VALUES (
@workPlanId_1, @memberId_1, @memberType_1)
GO

ALTER PROCEDURE WorkPlanExchange_WP_Add (
@workPlanId_1 int, @flag integer output , @msg varchar(80) output)
AS
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE all_cursor CURSOR FOR
SELECT DISTINCT userid, usertype FROM WorkPlanShareDetail WHERE workid = @workPlanId_1
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_userid, @m_usertype
WHILE (@@FETCH_STATUS = 0)
BEGIN 
EXEC WorkPlanExchange_Insert @workPlanId_1, @m_userid, @m_usertype, '', ''
FETCH NEXT FROM all_cursor INTO @m_userid, @m_usertype
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

ALTER PROCEDURE WorkPlanExchange_Add (
@workPlanId_1 int, @userId_1 int, @userType_1 char(1), @flag integer output , @msg varchar(80) output)
AS
IF NOT EXISTS(SELECT workPlanId FROM WorkPlanExchange WHERE workPlanId = @workPlanId_1)
EXEC WorkPlanExchange_WP_Add @workPlanId_1, '', ''
UPDATE WorkPlanExchange SET exchangeCount = exchangeCount + 1 
WHERE workPlanId = @workPlanId_1 AND 
((memberId <> @userId_1 AND memberType = @userType_1) OR memberType <> @userType_1)
GO

ALTER TABLE WorkPlan ADD finishRemind int DEFAULT 0
GO

UPDATE WorkPlan SET finishRemind = 0

INSERT INTO HtmlLabelIndex values(17532,'联系记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(17532,'联系记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17532,'Contact History',8) 
GO


INSERT INTO HtmlLabelIndex values(17533,'不打分') 
GO
INSERT INTO HtmlLabelInfo VALUES(17533,'不打分',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17533,'No Valuate',8) 
GO


CREATE PROCEDURE WorkPlan_InsertPlus (
	@type_n_1 char(1),
	@name_1 varchar(100),
	@resourceid_1 varchar(200),
	@begindate_1 char(10),
	@begintime_1 char(8),
	@enddate_1 char(10),
	@endtime_1 char(8),	
	@description_1 text,
	@requestid_1 varchar(100),
	@projectid_1 varchar(100),
	@crmid_1 varchar(100),
	@docid_1 varchar(100),
	@meetingid_1 varchar(100),
	@isremind_1 int,
	@waketime_1 int,	
	@createrid_1 int,
	@createrType_1 char(1),
	@createdate_1 char(10),
	@createtime_1 char(8),	
	@taskid_1 varchar(100),
	@urgentLevel_1 char(1),	
	@status_1 char(1),
	@flag integer output,
	@msg varchar(80) output)
AS INSERT INTO WorkPlan (
	type_n,
	name,
	resourceid,
	begindate,
	begintime,
	enddate,
	endtime,
	description,
	requestid,
	projectid,
	crmid,
	docid,
	meetingid,
	status,
	isremind,
	waketime,	
	createrid,
	createdate,
	createtime,
	deleted,
	taskid,
	urgentLevel,
	createrType
) VALUES (
	@type_n_1,
	@name_1,
	@resourceid_1,
	@begindate_1,
	@begintime_1,
	@enddate_1,
	@endtime_1,
	@description_1,
	@requestid_1,
	@projectid_1,
	@crmid_1,
	@docid_1,
	@meetingid_1,
	@status_1,
	@isremind_1,
	@waketime_1,	
	@createrid_1,
	@createdate_1,
	@createtime_1,
	'0',
	@taskid_1,
	@urgentLevel_1,
	@createrType_1
)

DECLARE @m_id int
DECLARE @m_deptId int
DECLARE @m_subcoId int

SELECT @m_id = MAX(id) FROM WorkPlan
SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id
SELECT @m_id AS id
GO

ALTER PROCEDURE WorkPlan_Update (
	@id_1 int,
	@name_1 varchar(100),
	@resourceid_1 varchar(200),
	@begindate_1 char(10),
	@begintime_1 char(8),
	@enddate_1 char(10),
	@endtime_1 char(8),	
	@description_1 text,
	@requestid_1 varchar(100),
	@projectid_1 varchar(100),
	@crmid_1 varchar(100),
	@docid_1 varchar(100),
	@meetingid_1 varchar(100),	
	@isremind_1 int,
	@waketime_1 int,
	@taskid_1 varchar(100),
	@urgentLevel_1 char(1),	
	@flag integer output,
	@msg varchar(80) output)
AS UPDATE WorkPlan SET
	name = @name_1,
	resourceid = @resourceid_1,
	begindate = @begindate_1,
	begintime = @begintime_1,
	enddate = @enddate_1,
	endtime  = @endtime_1,
	description = @description_1,
	requestid  = @requestid_1,
	projectid = @projectid_1,
	crmid  = @crmid_1,
	docid  = @docid_1,
	meetingid = @meetingid_1,
	isremind  = @isremind_1,
	waketime  = @waketime_1,	
	taskid = @taskid_1,
	urgentLevel = @urgentLevel_1	
WHERE id = @id_1
GO

INSERT INTO HtmlLabelIndex values(17541,'改变样式') 
GO
INSERT INTO HtmlLabelInfo VALUES(17541,'改变样式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17541,'Change Style',8) 
GO
INSERT INTO HtmlLabelIndex values(17560,'计划首页') 
GO
INSERT INTO HtmlLabelIndex values(17559,'新闻首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(17559,'新闻首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17559,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17560,'计划首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17560,'',8) 
GO
INSERT INTO HtmlLabelIndex values(17545,'无查看权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(17545,'无查看权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17545,'No Right',8) 
GO

