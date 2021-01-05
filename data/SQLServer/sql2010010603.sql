create table workflow_createplan(
	id int identity (1, 1) not null,
	wfid int null,
	nodeid int null,
	changetime int null,
	plantypeid int null,
	creatertype int null,
	wffieldid int null,
	remindType int null,
	remindBeforeStart int null,
	remindDateBeforeStart int null,
	remindTimeBeforeStart int null,
	remindBeforeEnd int null,
	remindDateBeforeEnd int null,
	remindTimeBeforeEnd int null
)
GO

create table workflow_createplangroup(
	id int identity (1, 1) not null,
	createplanid int null,
	groupid int null,
	isused int null
)
GO

create table workflow_createplandetail(
	id int identity (1, 1) not null,
	createplanid int null,
	wffieldid int null,
	isdetail int null,
	planfieldname varchar(50) null,
	groupid int null
)
GO
