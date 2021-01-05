create table mode_customtree(
	id int identity,
	treename varchar(200),
	treedesc varchar(4000),
	modeid int,
	creater int,
	createdate varchar(10),
	createtime varchar(8),
	rootname varchar(100),
	rooticon varchar(1000)
)
go
create table mode_customtreedetail(
	id int identity,
	mainid int,
	nodename varchar(200),
	nodedesc varchar(4000),
	sourcefrom int,
	sourceid int,
	tablename varchar(100),
	tablekey varchar(100),
	tablesup varchar(100),
	showfield varchar(100),
	hreftype int,
	hrefid int,
	hreftarget varchar(4000),
	hrefrelatefield varchar(100),
	nodeicon varchar(1000),
	supnode int,
	supnodefield varchar(100),
	nodefield varchar(100),
	showorder decimal(15,2)
)
go

create table mode_dataapprovalinfo(
	id int identity,
	billid int,
	modeid int,
	formid int,
	requestid int,
	operator int,
	operatedate varchar(10),
	operatetime varchar(8),
	approvalstatus int,
	approvaldate varchar(10),
	approvaltime varchar(8)
)
go

alter table mode_triggerworkflowset add successwriteback varchar(4000)
go
alter table mode_triggerworkflowset add failwriteback varchar(4000)
go