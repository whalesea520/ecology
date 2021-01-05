create table uf4mode_cptwfconf(
id int IDENTITY (1, 1) not null,
wftype varchar(20) null,
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
actname varchar(200) null
)
go
alter table uf4mode_cptwfconf add isopen char(1)
go
alter table uf4mode_cptwfconf add creater int
go
alter table uf4mode_cptwfconf add createdate char(10)
go
alter table uf4mode_cptwfconf add createtime char(8)
go
alter table uf4mode_cptwfconf add lastmoddate char(10)
go
alter table uf4mode_cptwfconf add lastmodtime char(8)
go
alter table uf4mode_cptwfconf add guid1 char(36)
go

create table uf4mode_cptwfactset(
id int IDENTITY (1, 1) not null,
mainid int null,
fieldid int null,
customervalue int null,
isnode int null,
objid int null,
isTriggerReject int null
)
go

create table uf4mode_cptwffieldmap(
id int IDENTITY (1, 1) not null,
mainid int null,
fieldtype int null,
fieldid int null,
fieldname varchar(50) null
)
go

create table uf4mode_cptwffrozennum(
id int IDENTITY (1, 1) not null,
requestid int null,
workflowid int null,
cptid int null,
frozennum decimal(10,2)
)
go