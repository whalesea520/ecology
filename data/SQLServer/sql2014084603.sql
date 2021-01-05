alter table WorkflowReportShare add allowlook int
GO
alter table WorkflowReportShare add seclevel2 int
GO
alter table rule_expressionbase add dbtype varchar(50)
GO
CREATE TABLE workflow_requestlogAtInfo
	(
	id              INT IDENTITY NOT NULL,
	REQUESTID       INT,
	WORKFLOWID      INT,
	nodeid          INT,
	LOGTYPE         CHAR (1),
	OPERATEDATE     VARCHAR (10),
	OPERATETIME     VARCHAR (8),
	OPERATOR        INT,
	atuserid        INT,
	forwardresource VARCHAR (max),
	PRIMARY KEY (id)
	)
GO
 ALTER PROCEDURE WorkflowReportShare_Insert (@reportid_1       int, @sharetype_1	int, @seclevel_1 int,@seclevel_2 int, @rolelevel_1	tinyint, @sharelevel_1	tinyint, @userid_1	[varchar](255), @subcompanyid_1	[varchar](255), @departmentid_1	[varchar](255), @roleid_1 [varchar](255), @foralluser_1	tinyint, @crmid_1	int, @mutidepartmentid_1 varchar(1000),@allowlook_1 int,@flag	int output, @msg	varchar(80)	output) as insert into WorkflowReportShare(reportid,sharetype,seclevel,seclevel2,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid,allowlook) values(@reportid_1,@sharetype_1,@seclevel_1,@seclevel_2,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@crmid_1,@mutidepartmentid_1,@allowlook_1) 
GO

alter table workflow_base add isfree char(1) default '0'
GO
update workflow_base set isfree = '0'
GO

ALTER PROCEDURE Workflow_ReportDspField_Insert (@reportid_1    [int], @fieldid_2   [int], @dsporder_3  [varchar](20), @isstat_4    [char](1), @dborder_5     char(1) , @dbordertype_6     char(1), @compositororder  [int],  @reportcondition_9 [int], @fieldwidth_10 [numeric](10,2) ,@valueone_11 [varchar](255),@valuetwo_12 [varchar](255),@valuethree_13 [varchar](255),@valuefour_14 [varchar](255),@httype_15 [varchar](10),@htdetailtype_16 [varchar](10), @flag   [int]   output, @msg    [varchar](80)   output) AS INSERT INTO [Workflow_ReportDspField] ( [reportid], [fieldid], [dsporder], [isstat],[dborder],[dbordertype],[compositororder],[reportcondition],[fieldwidth],[valueone],[valuetwo],[valuethree],[valuefour],[httype],[htdetailtype]) VALUES ( @reportid_1, @fieldid_2, @dsporder_3, @isstat_4, @dborder_5, @dbordertype_6,@compositororder,@reportcondition_9 ,@fieldwidth_10,@valueone_11,@valuetwo_12,@valuethree_13,@valuefour_14,@httype_15,@htdetailtype_16)
GO

ALTER PROCEDURE Workflow_RepDspFld_Insert_New (@reportid_1    [int], @dsporder_3  [varchar](20), @isstat_4    [char](1), @dborder_5     char(1) , @dbordertype_6     char(1), @compositororder_7  [int], @fieldidbak_8 [int], @reportcondition_9 [int], @fieldwidth_10 [numeric](10,2),@valueone_11 [varchar](255),@valuetwo_12 [varchar](255),@valuethree_13 [varchar](255),@valuefour_14 [varchar](255),@httype_15 [varchar](10),@htdetailtype_16 [varchar](10), @flag   [int]   output, @msg    [varchar](80)   output) AS INSERT INTO [Workflow_ReportDspField] ( [reportid], [dsporder], [isstat], [dborder],[dbordertype],[compositororder],[fieldidbak],[reportcondition],[fieldwidth],[valueone],[valuetwo],[valuethree],[valuefour],[httype],[htdetailtype]) VALUES ( @reportid_1, @dsporder_3, @isstat_4, @dborder_5, @dbordertype_6,@compositororder_7, @fieldidbak_8 ,@reportcondition_9 ,@fieldwidth_10,@valueone_11,@valuetwo_12,@valuethree_13,@valuefour_14,@httype_15,@htdetailtype_16)
GO


CREATE TABLE workflow_requestdeletelog (
	request_id int not null,
	request_name varchar(440),
	operate_userid int not null,
	operate_date char(10) not null,
	operate_time char(8) not null,
	workflow_id int not null,
	client_address char(15)
)
GO

alter table workflow_rquestBrowseFunction add jsqjtype_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add gdtype_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add xgkhid_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add xgxmid_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add createdate_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add createsubid_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add createdeptid_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add createtypeid_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add Processnumber_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add workflowtype_readonly char(1)
GO
alter table workflow_rquestBrowseFunction add requestname_readonly char(1)
GO

CREATE TABLE workflow_codeRegulate
	(
	id       INT NOT NULL identity(1,1),
	formid     INT NOT NULL,
	showId     INT NOT NULL,
	showType CHAR (1),
	codeValue  VARCHAR (100),
	codeOrder  INT,
	isBill     CHAR (1),
	workflowId INT
	)
GO

CREATE TABLE workflow_freeright(
	[nodeid] [int] NOT NULL,
	[isroutedit] [int] NOT NULL,
	[istableedit] [int] NOT NULL
) ON [PRIMARY]
GO

UPDATE workflow_browserurl SET labelid=33569 WHERE id=16
GO
UPDATE workflow_browserurl SET labelid=33924 WHERE id=152
GO
UPDATE workflow_browserurl SET labelid=33925 WHERE id=171
GO

create table rule_variablebase(
	id int  NOT NULL,
	name varchar(500) NULL,
	ruleid int NULL,
	fieldtype int NULL,
	htmltype int NULL
)
GO
create table rule_maplist
(
	id int identity NOT NULL,
	wfid int NULL,
	linkid int NULL,
	ruleid int NULL,
	isused int NULL,
	rulesrc int NULL,
	nm int NULL
)
GO
create table rule_mapitem
(
	id int identity NOT NULL,
	ruleid int NULL,
	rulesrc int NULL,
	linkid int NULL,
	rulevarid int NULL,
	formfieldid int NULL
)
GO

ALTER TABLE workflow_flownode ADD signfieldids VARCHAR(255)
GO

alter table rule_maplist add rowidenty int
GO
alter table rule_mapitem add rowidenty int
GO

CREATE TABLE workflow_groupdetail_matrix (
	groupdetailid INT NOT NULL,
	matrix INT NOT NULL,
	value_field INT NOT NULL
)
GO
CREATE TABLE workflow_matrixdetail (
	groupdetailid INT NOT NULL,
	condition_field INT NOT NULL,
	workflow_field INT NOT NULL
)
GO

ALTER TABLE workflow_createplan ADD changemode INT
GO

alter table rule_variablebase alter COLUMN  fieldtype varchar(10)
GO

ALTER  PROCEDURE WorkFlowTypeNodeTime_Get @sqlStr_1	varchar(4000), @flag 		integer 	output , @msg 		varchar(80) 	output AS exec (' select workflow_currentoperator.requestid, workflow_currentoperator.nodeid, (select requestname from workflow_requestbase where requestid=workflow_currentoperator.requestid ), (select nodename from workflow_nodebase where id=workflow_currentoperator.nodeid), 24*avg( convert(float, convert(datetime, case isremark when ''2'' then case operatedate when '''' then convert(char(10),getdate(),20) else operatedate end when null then isnull(operatedate,convert(char(10),getdate(),20)) else convert(char(10),getdate(),20) end +'' ''+ case isremark when ''2'' then case operatetime when '''' then convert(char(10),getdate(),108) else operatetime end when null then isnull(operatetime,convert(char(10),getdate(),108)) else convert(char(10),getdate(),108) end ) ) - convert(float,convert(datetime,receivedate+'' ''+receivetime))) from workflow_currentoperator,workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and (workflow_requestbase.status is not null and workflow_requestbase.status!='''') and workflowtype>1  and isremark<>4 '+@sqlStr_1+' and preisremark=''0'' and exists (select 1 from workflow_flownode where nodeid=workflow_currentoperator.nodeid and  workflowid=workflow_currentoperator.workflowid and nodetype<3) group by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid order by  workflow_currentoperator.requestid ,workflow_currentoperator.nodeid ')
GO
ALTER PROCEDURE MostExceedPerson_Get @sqlStr_1	varchar(4000), @flag 		integer 	output, @msg 		varchar(80) output AS exec (' select top  100 percent userid as userid,count(distinct workflow_requestbase.requestid) as counts, (select count(requestid) from workflow_requestbase b where exists (select 1 from workflow_currentoperator  a where a.requestid=b.requestid and a.userid=workflow_currentoperator.userid ) and b.status is not null and b.status!='''' ) as countall,  convert(float,count(distinct workflow_requestbase.requestid)*100)/convert(float,(select count(requestid) from workflow_requestbase b where exists (select 1 from workflow_currentoperator  a where a.requestid=b.requestid and a.userid=workflow_currentoperator.userid ) and b.status is not null and b.status!='''' ) ) as percents  from workflow_currentoperator,workflow_requestbase where  workflow_currentoperator.requestid=workflow_requestbase.requestid and (workflow_currentoperator.isprocessed = ''2'' or workflow_currentoperator.isprocessed = ''3'') and workflow_requestbase.status is not null and workflow_requestbase.status!='''' and exists (select 1 from workflow_nodelink where workflowid=workflow_requestbase.workflowid and (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3)) and (convert(float,nodepasshour)>0 or convert(float,nodepassminute)>0)) and isremark<>4 '+@sqlStr_1+' group by userid order by percents desc,userid desc')
GO
ALTER PROCEDURE WorkFlowPending_Get @sqlStr_1	varchar(4000), @flag 		integer 	output, @msg 		varchar(80) output AS exec (' SELECT TOP 100 PERCENT userid as userid, COUNT(requestid) AS counts FROM  workflow_currentoperator WHERE workflowtype > 0  and isremark IN (''0'', ''1'', ''5'',''8'',''9'',''7'') AND islasttimes = 1 AND usertype = ''0'' and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3)) and exists (select 1 from workflow_requestbase where requestid = workflow_currentoperator.requestid and (deleted=0 or deleted is null)) AND EXISTS (SELECT 1 FROM workflow_base WHERE id = workflow_currentoperator.workflowid AND (isvalid = 1 or isvalid=3)) '+@sqlStr_1+' GROUP BY userid ORDER BY COUNT(requestid) desc ')
GO

alter table workflow_nodelink add newrule varchar(200)
GO