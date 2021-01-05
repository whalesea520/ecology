alter table Prj_ProjectStatus add summary varchar(2000)
go
alter table Prj_ProjectStatus add dsporder decimal(10,2)
go
alter table Prj_ProjectStatus add issystem char(1)
go
alter table Prj_ProjectStatus add guid1 char(36)
go
update Prj_ProjectStatus set dsporder=id ,issystem='1' where id>=0 and id<=7
go
create table prj_prjwfconf(
id int IDENTITY (1, 1) not null,
wftype int null,
wfid int null,
formid int null,
prjtype int null,
isopen char(1),
isasync int null,
actname varchar(200) null,
creater int null,
createdate char(10),
createtime char(8),
lastmoddate char(10),
lastmodtime char(8),
xmjl int null,
xgxm int null,
xmmb int null,
cus1 int null,
cus2 int null,
cus3 int null,
cus4 int null,
cus5 int null,
cus6 int null,
cus7 int null,
cus8 int null
)
go

create table prj_prjwffieldmap(
id int IDENTITY (1, 1) not null,
mainid int null,
fieldtype int null,
fieldid int null,
fieldname varchar(50) null
)
go