create table mode_remindjob(
	id int primary key identity(1,1),
	name varchar(200),
	isenable int,
	remindtype int,
	formid int,
	modeid int,
	appid int,
	createtime varchar(20),
	creator int,
	remindtimetype int,
	reminddatefield int,
	remindtimefield int,
	reminddate varchar(20),
	remindtime varchar(20),
	incrementway int,
	incrementtype int,
	incrementfield int,
	incrementnum int,
	incrementunit int,
	remindway int,
	sendertype int,
	senderfield int,
	subject varchar(200),
	reminddml varchar(200),
	remindjava varchar(200),
	conditionstype int,
	conditionsfield varchar(4000),
	conditionsfieldcn varchar(4000),
	conditionssql varchar(4000),
	conditionsjava varchar(200),
	remindcontenttype int,
	remindcontenttext varchar(4000),
	remindcontentjava varchar(200),
	receivertype int,
	receiverdetail varchar(4000),
	receiverfieldtype int,
	receiverfield varchar(4000),
	receiverlevel int,
	triggerway int,
	triggertype int,
	triggerexpression varchar(200),
	triggercycletime int,
	weeks varchar(200),
	months varchar(200),
	days varchar(200)
 )
 go
 
create table mode_reminddata(
	id int primary key identity(1,1),
	billid int,
	modeid int,
	remindjobid int,
	reminddate varchar(10),
	remindtime varchar(10),
	status int
)
go

create table mode_reminddata_log(
	id int primary key identity(1,1),
	remindjobid int,
	lastreminddate varchar(10),
	lastremindtime varchar(10)
)
go