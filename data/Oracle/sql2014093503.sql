alter table SysMaintenanceLog add operateusertype int 
/
alter table SysMaintenanceLog modify operateitem varchar2(10)

/
alter table SystemLogItem modify  itemid varchar2(10)

/
delete from SystemLogItem where itemid='301'
/
insert into SystemLogItem values('301',30041,'文档',1)

/

CREATE TABLE ecology_log_operatetype(
	ID integer  NOT NULL primary key,
	operatetype int,
	mouldid int,
	operatetypelabel varchar(20) not null,
	operatetypedesc varchar(200)
)

/
create sequence ecology_log_operatetype_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "elog_operatetype_id_TRIGGER"
  before insert on ecology_log_operatetype
  for each row
begin
  select ecology_log_operatetype_id.nextval into :new.id from dual;
end;
/

delete from ecology_log_operatetype where operatetype=0 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(0,1,260,'阅读')

/
delete from ecology_log_operatetype where operatetype=1
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(1,82,'新建')
/
delete from ecology_log_operatetype where operatetype=2
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(2,103,'修改')
/
delete from ecology_log_operatetype where operatetype=3
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(3,91,'删除')
/
delete from ecology_log_operatetype where operatetype=4
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(4,1,142,'批准')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(4,78,'移动')
/
delete from ecology_log_operatetype where operatetype=5
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(5,1,236,'退回')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(5,77,'复制')
/
delete from ecology_log_operatetype where operatetype=6
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(6,1,21477,'重打开')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(6,674,'登陆')
/
delete from ecology_log_operatetype where operatetype=7
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(7,1,251,'归档')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(7,17589,'加密')
/
delete from ecology_log_operatetype where operatetype=8
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(8,1,256,'重载')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(8,17590,'取消加密')
/
delete from ecology_log_operatetype where operatetype=9
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(9,1,220,'草稿')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(9,236,'退回')
/
delete from ecology_log_operatetype where operatetype=10
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(10,1,117,'回复')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(10,22151,'封存')
/
delete from ecology_log_operatetype where operatetype=11
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(11,1,78,'移动')
/
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(11,22152,'解封')
/
delete from ecology_log_operatetype where operatetype=12 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(12,1,77,'复制')
/
delete from ecology_log_operatetype where operatetype=13 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(13,1,114,'发布')
/
delete from ecology_log_operatetype where operatetype=14 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(14,1,15750,'失效')
/
delete from ecology_log_operatetype where operatetype=15 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(15,1,15358,'作废')
/
delete from ecology_log_operatetype where operatetype=16 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(16,1,'611,22008','为文档添加新版本')
/
delete from ecology_log_operatetype where operatetype=17 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(17,1,21806,'强制签出')
/
delete from ecology_log_operatetype where operatetype=18 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(18,1,21807,'自动签出')
/
delete from ecology_log_operatetype where operatetype=19 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(19,1,19688,'强制签入')
/
delete from ecology_log_operatetype where operatetype=20 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(20,1,21808,'自动签入')
/
delete from ecology_log_operatetype where operatetype=21 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(21,1,257,'打印')
/
delete from ecology_log_operatetype where operatetype=22 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(22,1,31156,'下载')
/
delete from ecology_log_operatetype where operatetype=23 and mouldid=1
/
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(23,1,24357,'更改文档状态')
/

CREATE TABLE ecology_log_history(
	ID integer  NOT NULL primary key,
	tableName varchar(100) not null,
	modifyDate varchar(10) not null,
	tableDesc varchar(200)
)

/
create sequence ecology_log_history_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "elog_history_id_TRIGGER"
  before insert on ecology_log_history
  for each row
begin
  select ecology_log_history_id.nextval into :new.id from dual;
end;
/

create or replace  procedure SysMaintenanceLog_proc
(
relatedid in INTEGER,
relatedname in varchar2,
operateuserid in INTEGER ,
operateusertype in INTEGER,
operatetype in INTEGER,
operatedesc in varchar2,
operateitem in varchar2,
operatedate in char,
operatetime in char,
operatesmalltype in INTEGER,
clientaddress in char,
isTemplate in integer
) is

begin
insert into SysMaintenanceLog (
relatedid ,
relatedname ,
operateuserid ,
operateusertype ,
operatetype ,
operatedesc ,
operateitem ,
operatedate ,
operatetime ,
operatesmalltype ,
clientaddress ,
isTemplate
)
values
(
relatedid ,
relatedname ,
operateuserid ,
operateusertype ,
operatetype ,
operatedesc ,
operateitem ,
operatedate ,
operatetime ,
operatesmalltype ,
clientaddress,
isTemplate
);
end ;

/
alter table docdetaillog add operateitem varchar2(10) default '301'

/

update DocDetailLog set operateitem = '301' 

/

CREATE OR REPLACE  TRIGGER docdetaillog_trigger 
  before insert on docdetaillog
  for each row 
  begin
	SysMaintenanceLog_proc(:new.docid,
	:new.docsubject,
	:new.operateuserid ,
	:new.usertype,
	:new.operatetype,
	'',
	'301'
	:new.operatedate,
	:new.operatetime,
	1,
	:new.clientaddress,
	0 );
   end;
/