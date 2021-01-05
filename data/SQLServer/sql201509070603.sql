create table hpinfo_workflow (
	id int identity(1,1) primary key not null,
	infoname varchar(1000),
	styleid varchar(1000),
	layoutid int,
	isuse char(1),
	islocked int,
	creatortype int,
	creatorid int,
	menustyleid varchar(1000),
	wfid int,
	wfnid int,
	hpid int
)
GO
