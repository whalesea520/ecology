create table wsactionset(
	id int IDENTITY,
	actionname varchar(200),
	workflowid int,
	nodeid int,
	nodelinkid int,
	ispreoperator int,
	inpara varchar(200),
	actionorder int,
	wsurl varchar(400),
	wsoperation varchar(100),
	xmltext text,
	rettype int,
	retstr varchar(2000)
)
go
create table sapactionset(
	id int IDENTITY,
	actionname varchar(200),
	workflowid int,
	nodeid int,
	nodelinkid int,
	ispreoperator int,
	actionorder int,
	sapoperation varchar(100)
)
go
create table sapactionsetdetail(
	id int identity,
	mainid int,
	type int,
	paratype int,
	paraname varchar(100),
	paratext varchar(2000)
)
go

create view workflowactionview
as
	select d.id, d.dmlactionname as actionname, d.dmlorder as actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 0 as actiontype
	from dmlactionset d
	union
	select w.id, w.actionname, w.actionorder, w.nodeid, w.workflowId, w.nodelinkid, w.ispreoperator, 1 as actiontype
	from wsactionset w
	union
	select s.id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype
	from sapactionset s
go






