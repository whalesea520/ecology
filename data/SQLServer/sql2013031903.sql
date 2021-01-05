CREATE TABLE Taks_mainlineTask
	(
	id         INT IDENTITY NOT NULL,
	userid     INT NULL,
	mainlineid INT NULL,
	tasktype   INT NULL,
	taskid     INT NULL,
	CONSTRAINT PK_mainlineTask PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Taks_mainlineTask_Index_1 ON Taks_mainlineTask (taskid)
GO
CREATE NONCLUSTERED INDEX Taks_mainlineTask_Index_2 ON Taks_mainlineTask (mainlineid)
GO
CREATE TABLE Task_attention
	(
	id       INT IDENTITY NOT NULL,
	userid   INT NULL,
	tasktype INT NULL,
	taskid   INT NULL,
	CONSTRAINT PK_Task_attention PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_attention_Index_1 ON Task_attention (taskid)
GO
CREATE NONCLUSTERED INDEX Task_attention_Index_2 ON Task_attention (userid)
GO
CREATE TABLE Task_label
	(
	id         INT IDENTITY NOT NULL,
	name       VARCHAR (50) NULL,
	createor   INT NULL,
	createdate VARCHAR (25) NULL,
	CONSTRAINT PK_Task_label PRIMARY KEY (id)
	)
GO
CREATE TABLE Task_labelTask
	(
	id       INT IDENTITY NOT NULL,
	userid   INT NULL,
	labelid  INT NULL,
	tasktype INT NULL,
	taskid   INT NULL,
	CONSTRAINT PK_Task_labelTask PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_labelTask_Index_1 ON Task_labelTask (taskid)
GO
CREATE NONCLUSTERED INDEX Task_labelTask_Index_2 ON Task_labelTask (labelid)
GO
CREATE TABLE Task_mainline
	(
	id          INT IDENTITY NOT NULL,
	name        VARCHAR (50) NULL,
	createor    INT NULL,
	createdate  VARCHAR (25) NULL,
	modifydate  VARCHAR (25) NULL,
	principalid INT NULL,
	partnerids  VARCHAR (4000) NULL,
	remark      VARCHAR (4000) NULL,
	CONSTRAINT PK_Task_mainline PRIMARY KEY (id)
	)
GO
CREATE TABLE Task_mainlineShare
	(
	id         INT IDENTITY NOT NULL,
	userid     INT NULL,
	mainlineid INT NULL,
	usertype   INT NULL,
	CONSTRAINT PK_Task_mainlineShare PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_mainlineShare_Index_1 ON Task_mainlineShare (mainlineid)
GO
CREATE NONCLUSTERED INDEX Task_mainlineShare_Index_2 ON Task_mainlineShare (userid)
GO
CREATE TABLE Task_msg
	(
	id         INT IDENTITY NOT NULL,
	senderid   INT NULL,
	receiverid INT NULL,
	tasktype   INT NULL,
	taskid     INT NULL,
	content    VARCHAR (500) NULL,
	createdate VARCHAR (25) NULL,
	type       INT NULL,
	CONSTRAINT PK_Task_msg PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_msg_Index_1 ON Task_msg (receiverid)
GO
CREATE TABLE Task_operateLog
	(
	id         INT IDENTITY NOT NULL,
	tasktype   INT NULL,
	taskid     INT NULL,
	logid      INT NULL,
	workdate   CHAR (10) NULL,
	userid     INT NULL,
	createdate CHAR (10) NULL,
	createtime CHAR (8) NULL,
	logtype    INT NULL,
	CONSTRAINT PK_Task_operateLog PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_operateLog_Index_1 ON Task_operateLog (workdate)
GO
CREATE NONCLUSTERED INDEX Task_operateLog_Index_2 ON Task_operateLog (userid)
GO
CREATE TABLE Task_read
	(
	id     INT IDENTITY NOT NULL,
	userid INT NULL,
	taskid INT NULL,
	CONSTRAINT PK_Task_read PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_read_Index_1 ON Task_read (userid)
GO
CREATE TABLE Task_schedule
	(
	id       INT IDENTITY NOT NULL,
	userid   INT NULL,
	taskid   INT NULL,
	tasktype INT NULL,
	taskdate CHAR (10) NULL,
	CONSTRAINT PK_Task_schedule PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX Task_schedule_Index_1 ON Task_schedule (taskid)
GO
CREATE NONCLUSTERED INDEX Task_schedule_Index_2 ON Task_schedule (userid)
GO
CREATE TABLE TM_TaskFeedback
	(
	id         INT IDENTITY NOT NULL,
	taskid     INT NULL,
	content    TEXT NULL,
	hrmid      INT NULL,
	type       TINYINT NULL,
	docids     TEXT NULL,
	wfids      TEXT NULL,
	meetingids TEXT NULL,
	crmids     TEXT NULL,
	projectids TEXT NULL,
	fileids    TEXT NULL,
	createdate CHAR (10) NULL,
	createtime CHAR (8) NULL,
	CONSTRAINT PK_TM_TASKFEEDBACK PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TF_Index_1 ON TM_TaskFeedback (id)
GO
CREATE NONCLUSTERED INDEX TM_TF_Index_2 ON TM_TaskFeedback (taskid)
GO
CREATE NONCLUSTERED INDEX TM_TF_Index_3 ON TM_TaskFeedback (hrmid)
GO
CREATE TABLE TM_TaskInfo
	(
	id          INT IDENTITY NOT NULL,
	name        TEXT NULL,
	status      TINYINT NULL,
	typeid      INT NULL,
	tasklevel   TINYINT NULL, 
	remark      TEXT NULL,
	risk        TEXT NULL,
	difficulty  TEXT NULL,
	assist      TEXT NULL,
	tag         VARCHAR (100) NULL,
	arrangerid  INT NULL,
	principalid INT NULL,
	partnerids  TEXT NULL,
	begindate   CHAR (10) NULL,
	enddate     CHAR (10) NULL,
	parentid    INT NULL,
	taskids     TEXT NULL,
	docids      TEXT NULL,
	wfids       TEXT NULL,
	meetingids  TEXT NULL,
	crmids      TEXT NULL,
	projectids  TEXT NULL,
	goalids     TEXT NULL,
	planids     TEXT NULL,
	fileids     TEXT NULL,
	creater     INT NULL,
	createdate  CHAR (10) NULL,
	createtime  CHAR (8) NULL,
	updater     INT NULL,
	updatedate  CHAR (10) NULL,
	updatetime  CHAR (8) NULL,
	deleted     TINYINT NULL,
	CONSTRAINT PK_TM_TASKINFO PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TI_Index_1 ON TM_TaskInfo (id)
GO
CREATE NONCLUSTERED INDEX TM_TI_Index_2 ON TM_TaskInfo (arrangerid)
GO
CREATE NONCLUSTERED INDEX TM_TI_Index_3 ON TM_TaskInfo (principalid)
GO
CREATE NONCLUSTERED INDEX TM_TI_Index_4 ON TM_TaskInfo (parentid)
GO
CREATE TABLE TM_TaskLog
	(
	id           INT IDENTITY NOT NULL,
	taskid       INT NULL,
	type         INT NULL,
	operator     INT NULL,
	operatedate  CHAR (10) NULL,
	operatetime  CHAR (8) NULL,
	operatefiled VARCHAR (50) NULL,
	operatevalue TEXT NULL,
	CONSTRAINT PK_TM_TASKLOG PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TL_Index_1 ON TM_TaskLog (id)
GO
CREATE NONCLUSTERED INDEX TM_TL_Index_2 ON TM_TaskLog (taskid)
GO
CREATE TABLE TM_TaskPartner
	(
	id        INT IDENTITY NOT NULL,
	taskid    INT NULL,
	partnerid INT NULL,
	CONSTRAINT PK_TM_TASKPARTNER PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TP_Index_1 ON TM_TaskPartner (taskid)
GO
CREATE TABLE TM_TaskSharer
	(
	id       INT IDENTITY NOT NULL,
	taskid   INT NULL,
	sharerid INT NULL,
	CONSTRAINT PK_TM_TASKSHARER PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TS_Index_1 ON TM_TaskSharer (taskid)
GO
CREATE TABLE TM_TaskSpecial
	(
	id     INT IDENTITY NOT NULL,
	taskid INT NULL,
	userid INT NULL,
	CONSTRAINT PK_TM_TASKSPECIAL PRIMARY KEY (id)
	)
GO
CREATE NONCLUSTERED INDEX TM_TSL_Index_1 ON TM_TaskSpecial (taskid)
GO
CREATE NONCLUSTERED INDEX TM_TSL_Index_2 ON TM_TaskSpecial (userid)
GO
ALTER TABLE cowork_log ADD id INT IDENTITY
GO
CREATE NONCLUSTERED INDEX cowork_log_index_coworkid ON cowork_log (coworkid)
GO
CREATE NONCLUSTERED INDEX cowork_log_index_modifier ON cowork_log (modifier)
GO
CREATE NONCLUSTERED INDEX cowork_modifier_coworkid ON cowork_log (modifier,coworkid)
GO
CREATE NONCLUSTERED INDEX cowork_read_index_userid ON cowork_read (userid)
GO
CREATE NONCLUSTERED INDEX cowork_read_index_coworkid ON cowork_read (coworkid)
GO
CREATE NONCLUSTERED INDEX cowork_hidden_index_userid ON cowork_hidden (userid)
GO
CREATE NONCLUSTERED INDEX cowork_hidden_index_coworkid ON cowork_hidden (coworkid)
GO
CREATE NONCLUSTERED INDEX coworkshare_index_sourceid ON coworkshare (sourceid)
GO
UPDATE blog_AppItem SET face='/blog/images/mood-happy.png' WHERE id=1
GO
UPDATE blog_AppItem SET face='/blog/images/mood-unhappy.png' WHERE id=2
GO
CREATE TRIGGER task_cowork_log ON cowork_discuss FOR INSERT,DELETE 
AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT 
if exists(select 1 from inserted)
  BEGIN
   select @userid=discussant,@workdate=createdate,@taskid=coworkid,@logid=id from inserted 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(@userid,@workdate,5,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1)
  END 
ELSE if exists(select 1 from deleted)
  BEGIN
   select @userid=discussant,@workdate=createdate,@taskid=coworkid,@logid=id from deleted
   DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=5 AND taskid=@taskid
  END   
GO
CREATE TRIGGER task_crm_log ON WorkPlan FOR INSERT,DELETE 
AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT 
if exists(select 1 from inserted WHERE type_n=3)
  BEGIN
   select @userid=resourceid,@workdate=createdate,@taskid=crmid,@logid=id from inserted 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(@userid,@workdate,9,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1)
  END 
ELSE if exists(select 1 from deleted WHERE type_n=3)
  BEGIN
   select @userid=resourceid,@workdate=createdate,@taskid=crmid,@logid=id from deleted
   DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=9 AND taskid=@taskid
  END   
GO
CREATE TRIGGER task_tm_log ON TM_TaskFeedback FOR INSERT,DELETE 
AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT 
if exists(select 1 from inserted)
  BEGIN
   select @userid=hrmid,@workdate=createdate,@taskid=taskid,@logid=id from inserted 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(@userid,@workdate,1,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1)
  END 
ELSE if exists(select 1 from deleted)
  BEGIN
   select @userid=hrmid,@workdate=createdate,@taskid=taskid,@logid=id from deleted
   DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=1 AND taskid=@taskid
  END   
GO
CREATE TRIGGER task_workflow_log ON workflow_requestlog FOR INSERT,DELETE 
AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT 
if exists(select 1 from inserted)
  BEGIN
   select @userid=operator,@workdate=operatedate,@taskid=requestid,@logid=logid from inserted 
   insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) 
   VALUES(@userid,@workdate,2,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1)
  END 
ELSE if exists(select 1 from deleted)
  BEGIN
   select @userid=operator,@workdate=operatedate,@taskid=requestid,@logid=logid from deleted
   DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=2 AND taskid=@taskid
  END   
GO