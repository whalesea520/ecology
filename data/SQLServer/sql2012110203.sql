create table mode_wsactionset(
	id int IDENTITY,
	actionname varchar(200),
	modeid int,
	expandid int,
	inpara varchar(200),
	actionorder int,
	wsurl varchar(400),
	wsoperation varchar(100),
	xmltext text,
	rettype int,
	retstr varchar(2000)
)
go
create table mode_sapactionset(
	id int IDENTITY,
	actionname varchar(200),
	modeid int,
	expandid int,
	actionorder int,
	sapoperation varchar(100)
)
go
create table mode_sapactionsetdetail(
	id int identity,
	mainid int,
	type int,
	paratype int,
	paraname varchar(100),
	paratext varchar(2000)
)
go

create table mode_dmlactionset
(
       id int IDENTITY (1, 1) NOT NULL ,
       dmlactionname varchar(200) not null,
       dmlorder int,
		modeid int,
		expandid int,
       datasourceid varchar(200),
       dmltype varchar(10)
)
go
create table mode_dmlactionsqlset
(
       id int IDENTITY (1, 1) NOT NULL ,
       actionid integer,
       actiontable varchar(200),
       dmlformid int,
       dmlformname varchar(200),
       dmlisdetail int,
       dmltablename varchar(100),
       dmltablebyname varchar(100),
       dmlsql varchar(4000),
       dmlfieldtypes varchar(4000),
       dmlfieldnames varchar(4000),
       dmlothersql varchar(4000),
       dmlotherfieldtypes varchar(4000),
       dmlotherfieldnames varchar(4000),
       dmlcuswhere varchar(4000),
       dmlmainsqltype int,
       dmlcussql varchar(4000)
)
go
create table mode_dmlactionfieldmap
(
       id int IDENTITY (1, 1) NOT NULL ,
       actionsqlsetid integer,
       maptype char(1),
       fieldname varchar(200),
       fieldvalue varchar(200),
       fieldtype varchar(200)
)
go
create view mode_actionview
as
	select d.id, d.dmlactionname as actionname, d.dmlorder as actionorder, d.modeid, d.expandid, 0 as actiontype
	from mode_dmlactionset d
	union
	select w.id, w.actionname, w.actionorder, w.modeid, w.expandid, 1 as actiontype
	from mode_wsactionset w
	union
	select s.id, s.actionname, s.actionorder, s.modeid, s.expandid, 2 as actiontype
	from mode_sapactionset s
go