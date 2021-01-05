CREATE TABLE bill_worktaskapprove ( 
    id int IDENTITY,
    taskcode varchar(100),
    needcheck int,
    worktype int,
    important int,
    emergent int,
    taskcontent varchar(2000),
    liableperson text,
    coadjutant text,
    checkor int,
    ccuser text,
    planstartdate char(10),
    planstarttime char(10),
    planenddate char(10),
    planendtime char(10),
    plandays int,
    tasktype int,
    secrecylevel int,
    shareduser text,
    requestid int
) 
GO

create table SysPubRef(
	pubRefID int IDENTITY (1, 1) NOT NULL,
	masterCode varchar(100) null,
	masterName varchar(255) null,
	detailCode int null,
	detailName varchar(255) null,
	detailLabel int null,
	flag int null
)
GO

create table worktask_base(
	id int IDENTITY (1, 1) NOT NULL,
	name varchar(50) null,
	typecode varchar(10) null,
	isvalid int null,
	autotoplan int null,
	workplantypeid int null,
	orderid int null,
	useapprovewf int null,
	approvewf int null,
	remindtype int null,
	beforestart int null,
	beforestarttime int null,
	beforestarttype int null,
	beforestartper int null,
	beforeend int null,
	beforeendtime int null,
	beforeendtype int null,
	beforeendper int null,
	annexmaincategory int null,
	annexsubcategory int null,
	annexseccategory int null,
	issystem int null
)
GO

create table worktask_fielddict(
	id int IDENTITY (1, 1) NOT NULL,
	fieldname varchar(50) null,
	fielddbtype varchar(20) null,
	fieldhtmltype int null,
	type int null,
	description varchar(200) null,
	textheight int null,
	wttype int null,
	issystem int null
)
GO

create table worktask_taskfield(
	taskid int not null,
	fieldid int not null,
	crmname varchar(50) null,
	isshow int null,
	isedit int null,
	ismand int null,
	defaultvalue varchar(255) null,
	defaultvaluecn varchar(2000) null,
	orderid int null,
)
GO

create table worktask_tasklist(
	taskid int not null,
	fieldid int not null,
	isshowlist int null,
	width int null,
	orderidlist int null,
	isquery int null,
	isadvancedquery int null
)
GO

create table worktask_selectItem(
	id int IDENTITY (1, 1) NOT NULL,
	fieldid int null,
	selectvalue int null,
	selectname varchar(255) null,
	orderid int null
)
GO

create table worktask_form(
	requestid int NOT NULL,
	taskid int null
)
GO

create table worktaskshareset(
	id int IDENTITY (1, 1) NOT NULL,
	taskid int null,
	taskstatus int null,
	sharelevel int null,
	sharetype int null,
	seclevel int null,
	rolelevel int null,
	userid text null,
	subcompanyid text null,
	departmentid text null,
	roleid int null,
	foralluser int null,
	ssharetype int null,
	sseclevel int null,
	srolelevel int null,
	suserid text null,
	ssubcompanyid text null,
	sdepartmentid text null,
	sroleid int null,
	sforalluser int null,
	settype int null
)
GO

create table requestshareset(
	id int IDENTITY (1, 1) NOT NULL,
	taskid int null,
	requestid int null,
	creater int null,
	taskstatus int null,
	sharelevel int null,
	sharetype int null,
	seclevel int null,
	rolelevel int null,
	objid int null,
	foralluser int null,
	isdefault int null
)
GO

create table worktaskcreateshare(
	id int IDENTITY (1, 1) NOT NULL,
	taskid int null,
	seclevel int null,
	rolelevel int null,
	sharetype int null,
	userid int null,
	subcompanyid int null,
	departmentid int null,
	roleid int null,
	foralluser int null
)
GO

create table worktask_monitor(
	id int IDENTITY (1, 1) NOT NULL,
	taskid int null,
	monitor int null,
	monitortype int null
)
GO

create table worktask_code(
	taskid int null,
	currentcode varchar(100) null,
	isuse int null,
	codefield int null,
	worktaskseqalone int null,
	dateseqalone int null,
	dateseqselect int null
)
GO
delete from worktask_code where taskid=0
GO


create table worktask_codeSeq(
	id int IDENTITY (1, 1) NOT NULL,
	sequenceid int null,
	taskid int null,
	yearid int null,
	monthid int null,
	dateid int null
)
GO

create table worktask_codeSet(
	id int IDENTITY (1, 1) NOT NULL,
	showid int null,
	showtype int null
)
GO

create table worktask_codedetail(
	taskid int not null,
	showid int null,
	codevalue varchar(100) null,
	codeorder int null
)
GO

create table worktask_requestbase(
	requestid int NOT NULL,
	taskid int null,
	status int null,
	creater int null,
	createdate varchar(10) null,
	createtime varchar(10) null,
	deleted int null,
	useapprovewf int null,
	approverequest int null,
	remindtype int null,
	beforestart int null,
	beforestarttime int null,
	beforestarttype int null,
	beforestartper int null,
	beforeend int null,
	beforeendtime int null,
	beforeendtype int null,
	beforeendper int null,
	istemplate int null,
	sourceworktaskid int null,
	sourceworkflowid int null,
	wakemode int null,
	wakecreatetime varchar(10) null,
	wakefrequency int null,
	wakefrequencyy int null,
	wakecreatetype int null,
	waketimes int null,
	waketimetype int null,
	wakebegindate varchar(10) null,
	wakeenddate varchar(10) null
)
GO
create table worktask_requestsequence(
	requestid int not null
)
GO

create table worktask_operator(
	id int IDENTITY (1, 1) NOT NULL,
	requestid int null,
	userid int null,
	type int null,
	lastoptdate char(10) null,
	lastopttime char(10) null,
	checkdate char(10) null,
	checktime char(10) null,
	optstatus int null,
	viewtype int null
)
GO
create table worktask_backlog(
	id int IDENTITY (1, 1) NOT NULL,
	type int null,
	optstatus int null,
	operatorid int null,
	optuserid int null,
	optdate char(10) null,
	opttime char(10) null,
	opttype int null
)
GO

create table workflow_createtask(
	id int identity (1, 1) not null,
	wfid int null,
	nodeid int null,
	changetime int null,
	taskid int null,
	creatertype int null,
	wffieldid int null
)
GO

create table workflow_createtaskgroup(
	id int identity (1, 1) not null,
	createtaskid int null,
	groupid int null,
	isused int null
)
GO

create table workflow_createtaskdetail(
	id int identity (1, 1) not null,
	createtaskid int null,
	wffieldid int null,
	isdetail int null,
	wtfieldid int null,
	groupid int null,
	wffieldtype int null
)
GO

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(207,22162,'bill_worktaskapprove','AddBillWorktaskApprove.jsp','ManageBillWorktaskApprove.jsp','ViewBillWorktaskApprove.jsp','','','BillWorktaskApproveOperation.jsp') 
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'taskcode',22163,'varchar(100)',1,1,4,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'checkor',22164,'int',3,1,12,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'liableperson',16936,'text',3,17,9,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'important',848,'int',5,0,6,0,'')
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '一般', 1, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '重要', 2, 'n'
from workflow_billfield where billid=207
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'emergent',22165,'int',5,0,7,0,'')
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '一般', 1, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '重要', 2, 'n'
from workflow_billfield where billid=207
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'worktype',22166,'int',5,0,5,0,'')
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, 'A', 1, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, 'B', 2, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, 'C', 3, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 3, 'D', 4, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 4, 'E', 5, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 5, 'F', 6, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 6, 'G', 7, 'n'
from workflow_billfield where billid=207
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'taskcontent',22134,'varchar(2000)',2,0,8,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'coadjutant',20133,'text',3,17,10,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'ccuser',17051,'text',3,17,13,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'needcheck',22167,'int',4,0,4,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planstartdate',22168,'char(10)',3,2,13,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planstarttime',22169,'char(10)',3,19,14,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planenddate',22170,'char(10)',3,2,15,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planendtime',22171,'char(10)',3,19,16,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'plandays',22172,'int',1,2,17,0,'')
GO
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'tasktype',18078,'int',5,0,18,0,'')
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 3, '个人计划', 1, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, '部门计划', 2, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '分部计划', 3, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '集团计划', 4, 'n'
from workflow_billfield where billid=207
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'secrecylevel',19115,'int',5,0,19,0,'')
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '内部公开', 1, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '机密', 2, 'n'
from workflow_billfield where billid=207
GO
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, '绝密', 3, 'n'
from workflow_billfield where billid=207
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'shareduser',22173,'text',3,17,20,0,'')
GO

delete from SysPubRef where masterCode='WorkTaskStatus'
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 0, '所有状态', 21985, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 1, '未提交', 15178, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 2, '待审批', 2242, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 3, '被退回', 21983, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 4, '已取消', 20114, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 5, '待执行', 21981, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 6, '未开始', 1979, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 7, '进行中', 1960, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 8, '已超期', 21984, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 9, '待验证', 21982, 1)
GO
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 10, '已完成', 1961, 1)
GO

delete from worktask_base
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('工作安排', '', 1, 0, 1, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('年度计划', '', 1, 0, 2, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('季度计划', '', 1, 0, 3, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('月度计划', '', 1, 0, 4, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('每周计划', '', 1, 0, 5, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('每日计划', '', 1, 0, 6, 1)
GO
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('周期任务', '', 1, 0, 7, 1)
GO

delete from worktask_fielddict
GO
delete from worktask_taskfield
GO
delete from worktask_selectItem
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('taskcode', '工作编码', 'varchar(100)', 1, 1, 20, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 0, 0, 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 1, 0, 90
from worktask_fielddict
GO
alter table worktask_requestbase add taskcode varchar(100) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkor', '验证人', 'int', 3, 1, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 12
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 7, 1, 1, 90
from worktask_fielddict
GO
alter table worktask_requestbase add checkor int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('liableperson', '责任人', 'text', 3, 17, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 9
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 4, 1, 0, 90
from worktask_fielddict
GO
alter table worktask_requestbase add liableperson text null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('important', '重要性', 'int', 5, 0, 0, 1, 0)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 6
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '一般', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '重要', 2
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add important int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('emergent', '紧急性', 'int', 5, 0, 0, 1, 0)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 7
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '一般', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '紧急', 2
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add emergent int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('worktype', '工作性质', 'int', 5, 0, 0, 1, 0)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 5
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, 'A', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, 'B', 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, 'C', 3
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, 'D', 4
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 4, 'E', 5
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 5, 'F', 6
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 6, 'G', 7
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add worktype int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('taskcontent', '计划内容', 'varchar(2000)', 2, 0, 4, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 8
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 3, 1, 0, 250
from worktask_fielddict
GO
alter table worktask_requestbase add taskcontent varchar(2000) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('coadjutant', '协助人', 'text', 3, 17, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 10
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 5, 1, 1, 100
from worktask_fielddict
GO
alter table worktask_requestbase add coadjutant text null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('ccuser', '抄送人', 'text', 3, 17, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add ccuser text null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('needcheck', '是否验证', 'int', 4, 1, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 6, 1, 0, 60
from worktask_fielddict
GO
alter table worktask_requestbase add needcheck int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planstartdate', '计划开始日期', 'char(10)', 3, 2, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 13
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 9, 1, 0, 90
from worktask_fielddict
GO
alter table worktask_requestbase add planstartdate char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planstarttime', '计划开始时间', 'char(10)', 3, 19, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add planstarttime char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planenddate', '计划结束日期', 'char(10)', 3, 2, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 14
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 10, 1, 0, 90
from worktask_fielddict
GO
alter table worktask_requestbase add planenddate char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planendtime', '计划结束时间', 'char(10)', 3, 19, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add planendtime char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('plandays', '计划工期', 'int', 1, 2, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 15
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 11, 1, 1, 60
from worktask_fielddict
GO
alter table worktask_requestbase add plandays int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('remindnum', '提醒差值', 'int', 1, 2, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 16
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add remindnum int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('tasktype', '计划性质', 'int', 5, 0, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 19
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '个人计划', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '部门计划', 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '分部计划', 3
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '集团计划', 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 14, 1, 0, 60
from worktask_fielddict
GO
alter table worktask_requestbase add tasktype int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('secrecylevel', '保密级别', 'int', 5, 0, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '内部公开', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '机密', 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '绝密', 3
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add secrecylevel int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('shareduser', '可阅人员', 'text', 3, 17, 0, 1, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_requestbase add shareduser text null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('createstatus', '完成情况', 'int', 5, 0, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '完成', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '未完成', 2
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 1, 0, 0, 60
from worktask_fielddict
GO
alter table worktask_operator add createstatus int null
GO
alter table worktask_backlog add createstatus int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realstartdate', '实际开始日期', 'char(10)', 3, 2, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 2
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 0, 0, 90
from worktask_fielddict
GO
alter table worktask_operator add realstartdate char(10) null
GO
alter table worktask_backlog add realstartdate char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realstarttime', '实际开始时间', 'char(10)', 3, 19, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_operator add realstarttime char(10) null
GO
alter table worktask_backlog add realstarttime char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realenddate', '实际结束日期', 'char(10)', 3, 2, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 3
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 3, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_operator add realenddate char(10) null
GO
alter table worktask_backlog add realenddate char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realendtime', '实际结束时间', 'char(10)', 3, 19, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_operator add realendtime char(10) null
GO
alter table worktask_backlog add realendtime char(10) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realdays', '实际工期', 'int', 1, 2, 0, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 4, 0, 0, 60
from worktask_fielddict
GO
alter table worktask_operator add realdays int null
GO
alter table worktask_backlog add realdays int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('backremark', '反馈说明', 'varchar(2000)', 2, 1, 4, 2, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 5, 0, 0, 200
from worktask_fielddict
GO
alter table worktask_operator add backremark varchar(2000) null
GO
alter table worktask_backlog add backremark varchar(2000) null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkresult', '验证结果', 'int', 5, 0, 0, 3, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '验证退回', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '验证通过', 2
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 1, 0, 0, 60
from worktask_fielddict
GO
alter table worktask_operator add checkresult int null
GO
alter table worktask_backlog add checkresult int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('efficiency', '及时性', 'int', 5, 0, 0, 3, 0)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '提前完成', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '如期完成', 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '超期完成', 3
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_operator add efficiency int null
GO
alter table worktask_backlog add efficiency int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('complateresult', '完成效果', 'int', 5, 0, 0, 3, 0)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 3
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '与预期目标严重偏离', 1
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '达到预定目标', 2
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '按要求完成任务', 3
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 4, '圆满完成任务', 4
from worktask_fielddict
GO
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 5, '超额完成任务', 5
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
GO
alter table worktask_operator add complateresult int null
GO
alter table worktask_backlog add complateresult int null
GO

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkremark', '验证说明', 'varchar(2000)', 2, 1, 4, 3, 1)
GO
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
GO
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 0, 0, 200
from worktask_fielddict
GO
alter table worktask_operator add checkremark varchar(2000) null
GO
alter table worktask_backlog add checkremark varchar(2000) null
GO

delete from worktask_code where taskid=0
GO
insert into worktask_code(taskid, currentcode, isuse, codefield, worktaskseqalone, dateseqalone, dateseqselect)
select 0, '', 1, id, 0, 0, 0 from worktask_fielddict where fieldname = 'taskcode'
GO

insert into worktask_codeSet(showid, showtype) values (18729, 2)
GO
insert into worktask_codeSet(showid, showtype) values (445, 1)
GO
insert into worktask_codeSet(showid, showtype) values (6076, 1)
GO
insert into worktask_codeSet(showid, showtype) values (390, 1)
GO
insert into worktask_codeSet(showid, showtype) values (18811, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20571, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20572, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20573, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20574, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20575, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20770, 2)
GO
insert into worktask_codeSet(showid, showtype) values (20771, 2)
GO

insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 18729, '', 0)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 445, '', 1)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 6076, '', 2)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 390, '', 3)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 18811, '', 4)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20571, '', 5)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20572, '', 6)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20573, '', 7)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20574, '', 8)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20575, '', 9)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20770, '', 10)
GO
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20771, '', 11)
GO

insert into worktask_requestsequence(requestid)
values(0)
GO

CREATE  PROCEDURE WorkTaskShareSet_Insert (@taskid_1       int, @taskstatus_1	int,@sharetype_1	int, @seclevel_1	int, @rolelevel_1	int, 
@sharelevel_1	int, @userid_1	varchar(8000), @subcompanyid_1	varchar(8000), @departmentid_1	varchar(8000), 
@roleid_1	int, @foralluser_1	int, @sharetype_2	int, @seclevel_2	int, @rolelevel_2	int,
 @userid_2	varchar(8000), @subcompanyid_2	varchar(8000), @departmentid_2	varchar(8000), @roleid_2	int, @foralluser_2	int, 
 @settype_1	int,
@flag  	int output, @msg 	varchar output) as 
 insert into WorkTaskShareSet(taskid,taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,
departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) 
values(@taskid_1,@taskstatus_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@sharetype_2,
@seclevel_2,@rolelevel_2,@userid_2,@subcompanyid_2,@departmentid_2,@roleid_2,@foralluser_2,@settype_1)

go

CREATE PROCEDURE WorkTaskCreateShare_Insert (
@taskid	int,
@sharetype	int,
@seclevel	tinyint, 
@rolelevel	tinyint, 
@userid	int, 
@subcompanyid	int, 
@departmentid	int, 
@roleid	int, 
@foralluser	tinyint,
@flag	int output, 
@msg	varchar(80)	output
) 
as 
insert into WorkTaskCreateShare 
(taskid,sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser)
values (@taskid,@sharetype,@seclevel,@rolelevel,@userid,@subcompanyid,@departmentid,@roleid,@foralluser) 

GO

CREATE PROCEDURE WorkTaskCreateShare_Delete (@id	int, @flag	int output, @msg	varchar(80)	output) 
as delete from WorkTaskCreateShare where id=@id 

GO


CREATE PROCEDURE worktask_RequestID_Update(@flag int output , @msg varchar(80) output )
AS update worktask_requestsequence set requestid=requestid+1
select requestid from worktask_requestsequence

GO
