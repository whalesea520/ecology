create table worktask_requestlog(
	logid int IDENTITY (1, 1) NOT NULL,
	requestid int null,
	fieldid int null,
	oldvalue varchar(2000) null,
	newvalue varchar(2000) null,
	ipaddress varchar(20) null,
	optuserid int null,
	optdate varchar(10) null,
	opttime varchar(10) null
)
GO
