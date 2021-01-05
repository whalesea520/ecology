create table mode_impexp_log
(
	id int IDENTITY(1,1) NOT NULL,
	creator int not null,
	createdate varchar(10),
	createtime varchar(8),
	type int not null,
	datatype int not null,
	fileid int,
	objid int
)
go
create table mode_impexp_logdetail
(
	id int IDENTITY(1,1) NOT NULL,
	logid int not null,
	tablename varchar(50),
	logtype int not null,
	message varchar(1000)
)
go
create table mode_impexp_recorddetail
(
	id int IDENTITY(1,1) NOT NULL,
	tablename varchar(50) not null,
	columnname varchar(50) not null,
	columnvalue varchar(100),
	requestid varchar(32) not null,
	rollbackid varchar(32),
	ptype int not null
)
go