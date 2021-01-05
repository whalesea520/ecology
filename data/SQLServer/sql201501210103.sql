alter table prj_prjwfconf add guid1 char(36)
go

create table prj_prjwfactset(
id int IDENTITY (1, 1) not null,
mainid int null,
fieldid int null,
customervalue int null,
isnode int null,
objid int null,
isTriggerReject int null
)
go