create table uf4mode_cptwfconf(
id int  not null,
wftype varchar2(20) null,
wfid int null,
sqr int null,
zczl int null,
zc int null,
sl int null,
zcz int null,
jg int null,
rq int null,
ggxh int null,
cfdd int null,
bz int null,
wxqx int null,
wxdw int null,
isasync int null,
actname varchar2(200) null
)
/
create sequence uf4mode_cptwfconf_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger uf4mode_cptwfconf_trigger
before insert on uf4mode_cptwfconf
for each row
begin
select uf4mode_cptwfconf_id.nextval into :new.id from dual;
end;
/
alter table uf4mode_cptwfconf add isopen char(1)
/
alter table uf4mode_cptwfconf add creater int
/
alter table uf4mode_cptwfconf add createdate char(10)
/
alter table uf4mode_cptwfconf add createtime char(8)
/
alter table uf4mode_cptwfconf add lastmoddate char(10)
/
alter table uf4mode_cptwfconf add lastmodtime char(8)
/
alter table uf4mode_cptwfconf add guid1 char(36)
/

create table uf4mode_cptwfactset(
id int  not null,
mainid int null,
fieldid int null,
customervalue int null,
isnode int null,
objid int null,
isTriggerReject int null
)
/
create sequence uf4mode_cptwfactset_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger uf4mode_cptwfactset_TRIGGER before insert on uf4mode_cptwfactset for each row 
begin 
	select uf4mode_cptwfactset_ID.nextval into :new.id from dual; 
end;
/


create table uf4mode_cptwffieldmap(
id int  not null,
mainid int null,
fieldtype int null,
fieldid int null,
fieldname varchar2(50) null
)
/
create sequence uf4mode_cptwffieldmap_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger uf4mode_cptwffieldmap_TRIGGER before insert on uf4mode_cptwffieldmap for each row 
begin 
	select uf4mode_cptwffieldmap_ID.nextval into :new.id from dual; 
end;
/


create table uf4mode_cptwffrozennum(
id int  not null,
requestid int null,
workflowid int null,
cptid int null,
frozennum decimal(10,2)
)
/
create sequence uf4mode_cptwffrozennum_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger uf4mode_cptwffrozennum_TRIGGER before insert on uf4mode_cptwffrozennum for each row 
begin 
	select uf4mode_cptwffrozennum_ID.nextval into :new.id from dual; 
end;
/