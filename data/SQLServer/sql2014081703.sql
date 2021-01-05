alter table datasearchparam add wokflowfieldname varchar(200)
GO
CREATE TABLE formactionset(
	id int IDENTITY(1,1) NOT NULL,
	dmlactionname varchar(200) NOT NULL,
	formid int NULL,
	isbill int NULL,
	datasourceid varchar(200) NULL,
	dmltype varchar(10) NULL,
	typename char(1) NULL,
	oldactionid int,
      oldtype int
)
GO
delete from formactionset
GO
insert into formactionset
  (dmlactionname, formid, isbill, datasourceid, dmltype, typename,oldactionid,oldtype)
  select d.dmlactionname,
         b.formid,
         b.isbill,
         d.datasourceid,
         d.dmltype,
         d.typename,
		 d.id,1
    from dmlactionset d, workflow_base b
   where d.workflowid = b.id
GO
CREATE TABLE formactionsqlset(
	id int IDENTITY(1,1) NOT NULL,
	actionid int NULL,
	actiontable varchar(200) NULL,
	dmlformid int NULL,
	dmlformname varchar(200) NULL,
	dmlisdetail int NULL,
	dmltablename varchar(100) NULL,
	dmltablebyname varchar(100) NULL,
	dmlsql varchar(4000) NULL,
	dmlfieldtypes varchar(4000) NULL,
	dmlfieldnames varchar(4000) NULL,
	dmlothersql varchar(4000) NULL,
	dmlotherfieldtypes varchar(4000) NULL,
	dmlotherfieldnames varchar(4000) NULL,
	dmlcuswhere varchar(4000) NULL,
	dmlmainsqltype int NULL,
	dmlcussql varchar(4000) NULL,
	olddmlactionsqlsetid int
)
GO
delete from formactionsqlset
GO
insert into formactionsqlset
  (actionid,
   actiontable,
   dmlformid,
   dmlformname,
   dmlisdetail,
   dmltablename,
   dmltablebyname,
   dmlsql,
   dmlfieldtypes,
   dmlfieldnames,
   dmlothersql,
   dmlotherfieldtypes,
   dmlotherfieldnames,
   dmlcuswhere,
   dmlmainsqltype,
   dmlcussql,olddmlactionsqlsetid)
  select f.id,
         actiontable,
         dmlformid,
         dmlformname,
         dmlisdetail,
         dmltablename,
         dmltablebyname,
         dmlsql,
         dmlfieldtypes,
         dmlfieldnames,
         dmlothersql,
         dmlotherfieldtypes,
         dmlotherfieldnames,
         dmlcuswhere,
         dmlmainsqltype,
         dmlcussql,d.id
    from dmlactionsqlset d, formactionset f
   where d.actionid = f.oldactionid and f.oldtype=1
GO

CREATE TABLE formactionfieldmap(
	id int IDENTITY(1,1) NOT NULL,
	actionsqlsetid int NULL,
	maptype char(1) NULL,
	fieldname varchar(200) NULL,
	fieldvalue varchar(200) NULL,
	fieldtype varchar(200) NULL
)
GO
delete from formactionfieldmap
GO
insert into formactionfieldmap
  (actionsqlsetid, maptype, fieldname, fieldvalue, fieldtype)
  select b.id, d.maptype, d.fieldname, d.fieldvalue, d.fieldtype
    from dmlactionfieldmap d, formactionsqlset b
   where b.olddmlactionsqlsetid = d.actionsqlsetid
GO

CREATE TABLE wsformactionset(
	id int IDENTITY(1,1) NOT NULL,
	actionname varchar(200) NULL,
	formid int NULL,
	isbill int NULL,
	inpara varchar(200) NULL,
	actionorder int NULL,
	wsurl varchar(400) NULL,
	wsoperation varchar(100) NULL,
	xmltext text NULL,
	rettype int NULL,
	retstr varchar(2000) NULL,
	webservicefrom varchar(500) NULL,
	custominterface varchar(500) NULL,
	typename char(1) NULL,
	oldwsactionsetid int,
    oldtype int
)
GO
delete from wsformactionset
GO
insert into wsformactionset
  (actionname,
   formid,
   isbill,
   inpara,
   actionorder,
   wsurl,
   wsoperation,
   xmltext,
   rettype,
   retstr,
   webservicefrom,
   custominterface,
   typename,
   oldwsactionsetid,oldtype)
  select w.actionname,
         b.formid,
         b.isbill,
         w.inpara,
         w.actionorder,
         w.wsurl,
         w.wsoperation,
         w.xmltext,
         w.rettype,
         w.retstr,
         w.webservicefrom,
         w.custominterface,
         w.typename,
         w.id,2
    from wsactionset w, workflow_base b
   where w.workflowid = b.id
GO


create table workflowactionset
(
	id int IDENTITY(1,1) NOT NULL,
	actionname varchar(2000), 
	workflowid int, 
	nodeid int, 
	nodelinkid int, 
	ispreoperator int, 
	actionorder int, 
	interfaceid int,
	interfacetype int,
	typename varchar(100)
)
GO
delete from workflowactionset
GO
insert into workflowactionset
  (actionname,
   workflowid,
   nodeid,
   nodelinkid,
   ispreoperator,
   actionorder,
   interfaceid,
   interfacetype,
   typename)
  select o.dmlactionname,
         o.workflowid,
         o.nodeid,
         o.nodelinkid,
         o.ispreoperator,
         o.dmlorder,
         f.id,
         1,
         ''
    from dmlactionset o, formactionset f
   where o.id = f.oldactionid and f.oldtype=1
GO
insert into workflowactionset
  (actionname,
   workflowid,
   nodeid,
   nodelinkid,
   ispreoperator,
   actionorder,
   interfaceid,
   interfacetype,
   typename)
  select o.actionname,
         o.workflowid,
         o.nodeid,
         o.nodelinkid,
         o.ispreoperator,
         o.actionorder,
         f.id,
         2,
         ''
    from wsactionset o, wsformactionset f
   where o.id = f.oldwsactionsetid and f.oldtype=2
GO
drop view workflowactionview
GO
create view workflowactionview
as
	select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 0 as actiontype
	from workflowactionset d where d.interfacetype=1
	union
	select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 1 as actiontype
	from workflowactionset d where d.interfacetype=2
	union
	select s.id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype
	from sapactionset s
go