CREATE TABLE bill_worktaskapprove ( 
    id integer,
    taskcode varchar(100),
    needcheck integer,
    worktype integer,
    important integer,
    emergent integer,
    taskcontent varchar2(2000),
    liableperson varchar2(2000),
    coadjutant varchar2(2000),
    checkor integer,
    ccuser varchar2(2000),
    planstartdate char(10),
    planstarttime char(10),
    planenddate char(10),
    planendtime char(10),
    plandays integer,
    tasktype integer,
    secrecylevel integer,
    shareduser varchar2(2000),
    requestid integer
) 
/
create sequence bill_worktaskapprove_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger bill_worktaskapprove_id_Tri
before insert on bill_worktaskapprove
for each row
begin
select bill_worktaskapprove_id.nextval into :new.id from dual;
end;
/

create table SysPubRef(
	pubRefID integer NOT NULL,
	masterCode varchar(100) null,
	masterName varchar(255) null,
	detailCode integer null,
	detailName varchar(255) null,
	detailLabel integer null,
	flag integer null
)
/
create sequence SysPubRef_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SysPubRef_id_Tri
before insert on SysPubRef
for each row
begin
select SysPubRef_id.nextval into :new.pubRefID from dual;
end;
/

create table worktask_base(
	id integer NOT NULL,
	name varchar(50) null,
	typecode varchar(10) null,
	isvalid integer null,
	autotoplan integer null,
	workplantypeid integer null,
	orderid integer null,
	useapprovewf integer null,
	approvewf integer null,
	remindtype integer null,
	beforestart integer null,
	beforestarttime integer null,
	beforestarttype integer null,
	beforestartper integer null,
	beforeend integer null,
	beforeendtime integer null,
	beforeendtype integer null,
	beforeendper integer null,
	annexmaincategory integer null,
	annexsubcategory integer null,
	annexseccategory integer null,
	issystem integer null
)
/
create sequence worktask_base_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_base_id_Tri
before insert on worktask_base
for each row
begin
select worktask_base_id.nextval into :new.id from dual;
end;
/

create table worktask_fielddict(
	id integer NOT NULL,
	fieldname varchar(50) null,
	fielddbtype varchar(20) null,
	fieldhtmltype integer null,
	type integer null,
	description varchar(200) null,
	textheight integer null,
	wttype integer null,
	issystem integer null
)
/
create sequence worktask_fielddict_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_fielddict_id_Tri
before insert on worktask_fielddict
for each row
begin
select worktask_fielddict_id.nextval into :new.id from dual;
end;
/

create table worktask_taskfield(
	taskid integer not null,
	fieldid integer not null,
	crmname varchar(50) null,
	isshow integer null,
	isedit integer null,
	ismand integer null,
	defaultvalue varchar(255) null,
	defaultvaluecn varchar(2000) null,
	orderid integer null
)
/

create table worktask_tasklist(
	taskid integer not null,
	fieldid integer not null,
	isshowlist integer null,
	width integer null,
	orderidlist integer null,
	isquery integer null,
	isadvancedquery integer null
)
/

create table worktask_selectItem(
	id integer NOT NULL,
	fieldid integer null,
	selectvalue integer null,
	selectname varchar(255) null,
	orderid integer null
)
/
create sequence worktask_selectItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_selectItem_id_Tri
before insert on worktask_selectItem
for each row
begin
select worktask_selectItem_id.nextval into :new.id from dual;
end;
/

create table worktask_form(
	requestid integer NOT NULL,
	taskid integer null
)
/

create table worktaskshareset(
	id integer NOT NULL,
	taskid integer null,
	taskstatus integer null,
	sharelevel integer null,
	sharetype integer null,
	seclevel integer null,
	rolelevel integer null,
	userid varchar2(2000) null,
	subcompanyid varchar2(2000) null,
	departmentid varchar2(2000) null,
	roleid integer null,
	foralluser integer null,
	ssharetype integer null,
	sseclevel integer null,
	srolelevel integer null,
	suserid varchar2(2000) null,
	ssubcompanyid varchar2(2000) null,
	sdepartmentid varchar2(2000) null,
	sroleid integer null,
	sforalluser integer null,
	settype integer null
)
/
create sequence worktaskshareset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktaskshareset_id_Tri
before insert on worktaskshareset
for each row
begin
select worktaskshareset_id.nextval into :new.id from dual;
end;
/

create table requestshareset(
	id integer NOT NULL,
	taskid integer null,
	requestid integer null,
	creater integer null,
	taskstatus integer null,
	sharelevel integer null,
	sharetype integer null,
	seclevel integer null,
	rolelevel integer null,
	objid integer null,
	foralluser integer null,
	isdefault integer null
)
/
create sequence requestshareset_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger requestshareset_id_Tri
before insert on requestshareset
for each row
begin
select requestshareset_id.nextval into :new.id from dual;
end;
/

create table worktaskcreateshare(
	id integer NOT NULL,
	taskid integer null,
	seclevel integer null,
	rolelevel integer null,
	sharetype integer null,
	userid integer null,
	subcompanyid integer null,
	departmentid integer null,
	roleid integer null,
	foralluser integer null
)
/
create sequence worktaskcreateshare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktaskcreateshare_id_Tri
before insert on worktaskcreateshare
for each row
begin
select worktaskcreateshare_id.nextval into :new.id from dual;
end;
/

create table worktask_monitor(
	id integer NOT NULL,
	taskid integer null,
	monitor integer null,
	monitortype integer null
)
/
create sequence worktask_monitor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_monitor_id_Tri
before insert on worktask_monitor
for each row
begin
select worktask_monitor_id.nextval into :new.id from dual;
end;
/

create table worktask_code(
	taskid integer null,
	currentcode varchar(100) null,
	isuse integer null,
	codefield integer null,
	worktaskseqalone integer null,
	dateseqalone integer null,
	dateseqselect integer null
)
/

create table worktask_codeSeq(
	id integer NOT NULL,
	sequenceid integer null,
	taskid integer null,
	yearid integer null,
	monthid integer null,
	dateid integer null
)
/
create sequence worktask_codeSeq_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_codeSeq_id_Tri
before insert on worktask_codeSeq
for each row
begin
select worktask_codeSeq_id.nextval into :new.id from dual;
end;
/

create table worktask_codeSet(
	id integer NOT NULL,
	showid integer null,
	showtype integer null
)
/
create sequence worktask_codeSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_codeSet_id_Tri
before insert on worktask_codeSet
for each row
begin
select worktask_codeSet_id.nextval into :new.id from dual;
end;
/

create table worktask_codedetail(
	taskid integer not null,
	showid integer null,
	codevalue varchar(100) null,
	codeorder integer null
)
/

create table worktask_requestbase(
	requestid integer NOT NULL,
	taskid integer null,
	status integer null,
	creater integer null,
	createdate varchar(10) null,
	createtime varchar(10) null,
	deleted integer null,
	useapprovewf integer null,
	approverequest integer null,
	remindtype integer null,
	beforestart integer null,
	beforestarttime integer null,
	beforestarttype integer null,
	beforestartper integer null,
	beforeend integer null,
	beforeendtime integer null,
	beforeendtype integer null,
	beforeendper integer null,
	istemplate integer null,
	sourceworktaskid integer null,
	sourceworkflowid integer null,
	wakemode integer null,
	wakecreatetime varchar(10) null,
	wakefrequency integer null,
	wakefrequencyy integer null,
	wakecreatetype integer null,
	waketimes integer null,
	waketimetype integer null,
	wakebegindate varchar(10) null,
	wakeenddate varchar(10) null
)
/
create table worktask_requestsequence(
	requestid integer not null
)
/

create table worktask_operator(
	id integer NOT NULL,
	requestid integer null,
	userid integer null,
	type integer null,
	lastoptdate char(10) null,
	lastopttime char(10) null,
	checkdate char(10) null,
	checktime char(10) null,
	optstatus integer null,
	viewtype integer null
)
/
create sequence worktask_operator_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_operator_id_Tri
before insert on worktask_operator
for each row
begin
select worktask_operator_id.nextval into :new.id from dual;
end;
/

create table worktask_backlog(
	id integer NOT NULL,
	type integer null,
	optstatus integer null,
	operatorid integer null,
	optuserid integer null,
	optdate char(10) null,
	opttime char(10) null,
	opttype integer null
)
/
create sequence worktask_backlog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger worktask_backlog_id_Tri
before insert on worktask_backlog
for each row
begin
select worktask_backlog_id.nextval into :new.id from dual;
end;
/

create table workflow_createtask(
	id integer not null,
	wfid integer null,
	nodeid integer null,
	changetime integer null,
	taskid integer null,
	creatertype integer null,
	wffieldid integer null
)
/
create sequence workflow_createtask_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_createtask_id_Tri
before insert on workflow_createtask
for each row
begin
select workflow_createtask_id.nextval into :new.id from dual;
end;
/

create table workflow_createtaskgroup(
	id integer not null,
	createtaskid integer null,
	groupid integer null,
	isused integer null
)
/
create sequence workflow_createtaskgroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_ctgroup_id_Tri
before insert on workflow_createtaskgroup
for each row
begin
select workflow_createtaskgroup_id.nextval into :new.id from dual;
end;
/

create table workflow_createtaskdetail(
	id integer not null,
	createtaskid integer null,
	wffieldid integer null,
	isdetail integer null,
	wtfieldid integer null,
	groupid integer null,
	wffieldtype integer null
)
/
create sequence workflow_createtaskdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_ctdetail_id_Tri
before insert on workflow_createtaskdetail
for each row
begin
select workflow_createtaskdetail_id.nextval into :new.id from dual;
end;
/


create or replace procedure worktask_RequestID_Update(flag out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor )
AS update worktask_requestsequence set requestid=requestid+1
select requestid from worktask_requestsequence

/

create or replace procedure  WorkTaskShareSet_Insert (taskid_1       integer, taskstatus_1	integer,sharetype_1	integer, seclevel_1	integer, rolelevel_1	integer, 
sharelevel_1	integer, userid_1	varchar2, subcompanyid_1	varchar2, departmentid_1	varchar2, 
roleid_1	integer, foralluser_1	integer, sharetype_2	integer, seclevel_2	integer, rolelevel_2	integer,
 userid_2	varchar2, subcompanyid_2	varchar2, departmentid_2	varchar2, roleid_2	integer, foralluser_2	integer, 
 settype_1	integer,
flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as 
 insert into WorkTaskShareSet(taskid,taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,
departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) 
values(taskid_1,taskstatus_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,sharetype_2,
seclevel_2,rolelevel_2,userid_2,subcompanyid_2,departmentid_2,roleid_2,foralluser_2,settype_1)

/

create or replace procedure WorkTaskCreateShare_Insert (
taskid_1	integer,
sharetype_1	integer,
seclevel_1	integer, 
rolelevel_1	integer, 
userid_1	integer, 
subcompanyid_1	integer, 
departmentid_1	integer, 
roleid_1	integer, 
foralluser_1	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
insert into WorkTaskCreateShare 
(taskid,sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser)
values (taskid_1, sharetype_1, seclevel_1, rolelevel_1, userid_1, subcompanyid_1, departmentid_1, roleid_1, foralluser_1) 

/

create or replace procedure WorkTaskCreateShare_Delete (id_1	integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
as 
delete from WorkTaskCreateShare where id=id_1
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(207,22162,'bill_worktaskapprove','AddBillWorktaskApprove.jsp','ManageBillWorktaskApprove.jsp','ViewBillWorktaskApprove.jsp','','','BillWorktaskApproveOperation.jsp') 
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'taskcode',22163,'varchar(100)',1,1,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'checkor',22164,'integer',3,1,12,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'liableperson',16936,'varchar2(2000)',3,17,9,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'important',848,'integer',5,0,6,0,'')
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '一般', 1, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '重要', 2, 'n'
from workflow_billfield where billid=207
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'emergent',22165,'integer',5,0,7,0,'')
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '一般', 1, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '重要', 2, 'n'
from workflow_billfield where billid=207
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'worktype',22166,'integer',5,0,5,0,'')
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, 'A', 1, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, 'B', 2, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, 'C', 3, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 3, 'D', 4, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 4, 'E', 5, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 5, 'F', 6, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 6, 'G', 7, 'n'
from workflow_billfield where billid=207
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'taskcontent',22134,'varchar2(2000)',2,0,8,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'coadjutant',20133,'varchar2(2000)',3,17,10,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'ccuser',17051,'varchar2(2000)',3,17,13,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'needcheck',22167,'integer',4,0,4,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planstartdate',22168,'char(10)',3,2,13,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planstarttime',22169,'char(10)',3,19,14,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planenddate',22170,'char(10)',3,2,15,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'planendtime',22171,'char(10)',3,19,16,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'plandays',22172,'integer',1,2,17,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'tasktype',18078,'integer',5,0,18,0,'')
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 3, '个人计划', 1, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, '部门计划', 2, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '分部计划', 3, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '集团计划', 4, 'n'
from workflow_billfield where billid=207
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'secrecylevel',19115,'integer',5,0,19,0,'')
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 0, '内部公开', 1, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 1, '机密', 2, 'n'
from workflow_billfield where billid=207
/
insert into workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault)
select max(id), 1, 2, '绝密', 3, 'n'
from workflow_billfield where billid=207
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (207,'shareduser',22173,'varchar2(2000)',3,17,20,0,'')
/

delete from SysPubRef where masterCode='WorkTaskStatus'
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 0, '所有状态', 21985, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 1, '未提交', 15178, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 2, '待审批', 2242, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 3, '被退回', 21983, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 4, '已取消', 20114, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 5, '待执行', 21981, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 6, '未开始', 1979, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 7, '进行中', 1960, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 8, '已超期', 21984, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 9, '待验证', 21982, 1)
/
insert into SysPubRef (masterCode,masterName,detailCode,detailName,detailLabel,flag) values ('WorkTaskStatus', '计划任务状态', 10, '已完成', 1961, 1)
/

delete from worktask_base
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('工作安排', '', 1, 0, 1, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('年度计划', '', 1, 0, 2, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('季度计划', '', 1, 0, 3, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('月度计划', '', 1, 0, 4, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('每周计划', '', 1, 0, 5, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('每日计划', '', 1, 0, 6, 1)
/
insert into worktask_base(name, typecode, isvalid, autotoplan, orderid, issystem) values('周期任务', '', 1, 0, 7, 1)
/

delete from worktask_fielddict
/
delete from worktask_taskfield
/
delete from worktask_selectItem
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('taskcode', '工作编码', 'varchar(100)', 1, 1, 20, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 0, 0, 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 1, 0, 90
from worktask_fielddict
/
alter table worktask_requestbase add taskcode varchar(100) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkor', '验证人', 'integer', 3, 1, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 12
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 7, 1, 1, 90
from worktask_fielddict
/
alter table worktask_requestbase add checkor integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('liableperson', '责任人', 'varchar2(2000)', 3, 17, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 9
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 4, 1, 0, 90
from worktask_fielddict
/
alter table worktask_requestbase add liableperson varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('important', '重要性', 'integer', 5, 0, 0, 1, 0)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 6
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '一般', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '重要', 2
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add important integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('emergent', '紧急性', 'integer', 5, 0, 0, 1, 0)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 7
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '一般', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '紧急', 2
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add emergent integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('worktype', '工作性质', 'integer', 5, 0, 0, 1, 0)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 5
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, 'A', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, 'B', 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, 'C', 3
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, 'D', 4
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 4, 'E', 5
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 5, 'F', 6
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 6, 'G', 7
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add worktype integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('taskcontent', '计划内容', 'varchar(2000)', 2, 0, 4, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 8
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 3, 1, 0, 250
from worktask_fielddict
/
alter table worktask_requestbase add taskcontent varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('coadjutant', '协助人', 'varchar2(2000)', 3, 17, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 10
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 5, 1, 1, 100
from worktask_fielddict
/
alter table worktask_requestbase add coadjutant varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('ccuser', '抄送人', 'varchar2(2000)', 3, 17, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add ccuser varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('needcheck', '是否验证', 'integer', 4, 1, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 0, 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 6, 1, 0, 60
from worktask_fielddict
/
alter table worktask_requestbase add needcheck integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planstartdate', '计划开始日期', 'char(10)', 3, 2, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 13
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 9, 1, 0, 90
from worktask_fielddict
/
alter table worktask_requestbase add planstartdate char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planstarttime', '计划开始时间', 'char(10)', 3, 19, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add planstarttime char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planenddate', '计划结束日期', 'char(10)', 3, 2, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 14
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 10, 1, 0, 60
from worktask_fielddict
/
alter table worktask_requestbase add planenddate char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('planendtime', '计划结束时间', 'char(10)', 3, 19, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add planendtime char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('plandays', '计划工期', 'integer', 1, 2, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 15
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 11, 1, 1, 60
from worktask_fielddict
/
alter table worktask_requestbase add plandays integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('remindnum', '提醒差值', 'integer', 1, 2, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 16
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add remindnum integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('tasktype', '计划性质', 'integer', 5, 0, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 19
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '个人计划', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '部门计划', 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '分部计划', 3
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '集团计划', 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 14, 1, 0, 60
from worktask_fielddict
/
alter table worktask_requestbase add tasktype integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('secrecylevel', '保密级别', 'integer', 5, 0, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '内部公开', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '机密', 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '绝密', 3
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add secrecylevel integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('shareduser', '可阅人员', 'varchar2(2000)', 3, 17, 0, 1, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_requestbase add shareduser varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('createstatus', '完成情况', 'integer', 5, 0, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 0, '完成', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '未完成', 2
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 1, 0, 0, 60
from worktask_fielddict
/
alter table worktask_operator add createstatus integer null
/
alter table worktask_backlog add createstatus integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realstartdate', '实际开始日期', 'char(10)', 3, 2, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 2
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 0, 0, 90
from worktask_fielddict
/
alter table worktask_operator add realstartdate char(10) null
/
alter table worktask_backlog add realstartdate char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realstarttime', '实际开始时间', 'char(10)', 3, 19, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_operator add realstarttime char(10) null
/
alter table worktask_backlog add realstarttime char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realenddate', '实际结束日期', 'char(10)', 3, 2, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 1, 1, 1, 3
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 3, 0, 0, 90
from worktask_fielddict
/
alter table worktask_operator add realenddate char(10) null
/
alter table worktask_backlog add realenddate char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realendtime', '实际结束时间', 'char(10)', 3, 19, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid)
select 0, max(id), '', 0, 0, 0, 0
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_operator add realendtime char(10) null
/
alter table worktask_backlog add realendtime char(10) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('realdays', '实际工期', 'integer', 1, 2, 0, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 4, 0, 0, 60
from worktask_fielddict
/
alter table worktask_operator add realdays integer null
/
alter table worktask_backlog add realdays integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('backremark', '反馈说明', 'varchar(2000)', 2, 1, 4, 2, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 5, 0, 0, 200
from worktask_fielddict
/
alter table worktask_operator add backremark varchar(2000) null
/
alter table worktask_backlog add backremark varchar(2000) null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkresult', '验证结果', 'integer', 5, 0, 0, 3, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '验证退回', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '验证通过', 2
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 1, 0, 0, 60
from worktask_fielddict
/
alter table worktask_operator add checkresult integer null
/
alter table worktask_backlog add checkresult integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('efficiency', '及时性', 'integer', 5, 0, 0, 3, 0)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '提前完成', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '如期完成', 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '超期完成', 3
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_operator add efficiency integer null
/
alter table worktask_backlog add efficiency integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('complateresult', '完成效果', 'integer', 5, 0, 0, 3, 0)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 0, 3
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 1, '与预期目标严重偏离', 1
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 2, '达到预定目标', 2
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 3, '按要求完成任务', 3
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 4, '圆满完成任务', 4
from worktask_fielddict
/
insert into worktask_selectItem(fieldid, selectvalue, selectname, orderid)
select max(id), 5, '超额完成任务', 5
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 0, 0, 0, 0, 0
from worktask_fielddict
/
alter table worktask_operator add complateresult integer null
/
alter table worktask_backlog add complateresult integer null
/

insert into worktask_fielddict(fieldname, description, fielddbtype, fieldhtmltype, type, textheight, wttype, issystem) values('checkremark', '验证说明', 'varchar(2000)', 2, 1, 4, 3, 1)
/
insert into worktask_taskfield(taskid, fieldid, crmname, isshow, isedit, ismand, orderid) 
select 0, max(id), '', 1, 1, 1, 4
from worktask_fielddict
/
insert into worktask_tasklist(taskid, fieldid, isshowlist, orderidlist, isquery, isadvancedquery, width) 
select 0, max(id), 1, 2, 0, 0, 200
from worktask_fielddict
/
alter table worktask_operator add checkremark varchar2(2000) null
/
alter table worktask_backlog add checkremark varchar2(2000) null
/
delete from worktask_code where taskid=0
/
insert into worktask_code(taskid, currentcode, isuse, codefield, worktaskseqalone, dateseqalone, dateseqselect)
select 0, '', 1, id, 0, 0, 0 from worktask_fielddict where fieldname = 'taskcode'
/

insert into worktask_codeSet(showid, showtype) values (18729, 2)
/
insert into worktask_codeSet(showid, showtype) values (445, 1)
/
insert into worktask_codeSet(showid, showtype) values (6076, 1)
/
insert into worktask_codeSet(showid, showtype) values (390, 1)
/
insert into worktask_codeSet(showid, showtype) values (18811, 2)
/
insert into worktask_codeSet(showid, showtype) values (20571, 2)
/
insert into worktask_codeSet(showid, showtype) values (20572, 2)
/
insert into worktask_codeSet(showid, showtype) values (20573, 2)
/
insert into worktask_codeSet(showid, showtype) values (20574, 2)
/
insert into worktask_codeSet(showid, showtype) values (20575, 2)
/
insert into worktask_codeSet(showid, showtype) values (20770, 2)
/
insert into worktask_codeSet(showid, showtype) values (20771, 2)
/

insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 18729, '', 0)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 445, '', 1)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 6076, '', 2)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 390, '', 3)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 18811, '', 4)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20571, '', 5)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20572, '', 6)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20573, '', 7)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20574, '', 8)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20575, '', 9)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20770, '', 10)
/
insert into worktask_codedetail(taskid, showid, codevalue, codeorder) values (0, 20771, '', 11)
/

insert into worktask_requestsequence(requestid)
values(0)
/


