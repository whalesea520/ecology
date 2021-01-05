create table worktask_monitorlog(
	id int IDENTITY,
	requestid int,
	taskcontent varchar(500),
	requeststatus int,
	opter int,
	optdate varchar(10),
	opttime varchar(10),
	opttype int
)
GO
