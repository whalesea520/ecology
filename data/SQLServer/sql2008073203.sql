alter table Voting add isSeeResult varchar(10)
go
alter table votingquestion add ismultino int
go

ALTER  PROCEDURE Voting_Insert (
	@subject   varchar(100), 
	@detail    text, 
	@createrid int, 
	@createdate    char(10), 
	@createtime    char(8), 
	@approverid    int, 
	@approvedate   char(10), 
	@approvetime   char(8), 
	@begindate     char(10), 
	@begintime     char(8), 
	@enddate       char(10), 
	@endtime       char(8), 
	@isanony       int, 
	@docid         int, 
	@crmid     int, 
	@projid    int, 
	@requestid int, 
	@votingcount   int, 
	@status        int, 
	@isSeeResult varchar(10), 
	@flag integer output, 
	@msg varchar(80) output
) AS 
insert into voting (
	subject,
	detail,
	createrid,
	createdate,
	createtime,
	approverid,
	approvedate,
	approvetime,
	begindate,
	begintime,
	enddate,
	endtime,
	isanony,
	docid,
	crmid,
	projid,
	requestid,
	votingcount,
	status,
	isSeeResult) 
values (
	@subject,
	@detail,
	@createrid,
	@createdate,
	@createtime,
	@approverid,
	@approvedate,
	@approvetime,
	@begindate,
	@begintime,
	@enddate,
	@endtime,
	@isanony,
	@docid,
	@crmid,
	@projid,
	@requestid,
	@votingcount,
	@status,
	@isSeeResult
)  
select max(id) from voting
go

ALTER  PROCEDURE Voting_Update (
	@id    int, 
	@subject   varchar(100), 
	@detail    text, 
	@createrid int, 
	@createdate    char(10), 
	@createtime    char(8), 
	@approverid    int, 
	@approvedate   char(10), 
	@approvetime   char(8), 
	@begindate     char(10), 
	@begintime     char(8), 
	@enddate       char(10), 
	@endtime       char(8), 
	@isanony       int, 
	@docid         int, 
	@crmid     int, 
	@projid    int, 
	@requestid int, 
	@isSeeResult varchar(10),  
	@flag integer output, 
	@msg varchar(80) output
) 
AS 
update voting 
set 
	subject=@subject, 
	detail=@detail, 
	createrid=@createrid, 
	createdate=@createdate, 
	createtime=@createtime, 
	approverid=@approverid, 
	approvedate=@approvedate, 
	approvetime=@approvetime, 
	begindate=@begindate, 
	begintime=@begintime, 
	enddate=@enddate, 
	endtime=@endtime, 
	isanony=@isanony, 
	docid=@docid, 
	crmid=@crmid, 
	projid=@projid, 
	requestid=@requestid, 
	isSeeResult=@isSeeResult 
	where id=@id
go

ALTER  PROCEDURE VotingQuestion_Insert (
	@votingid  int, 
	@subject   varchar(100), 
	@description   varchar(255), 
	@ismulti       int, 
	@isother       int, 
	@questioncount int, 
        @ismultino int,
	@flag integer output, 
	@msg varchar(80) output
) 
AS 
insert into votingquestion (
	votingid,
	subject,
	description,
	ismulti,
	isother,
	questioncount,
	ismultino
) 
values (
	@votingid,
	@subject,
	@description,
	@ismulti,
	@isother,
	@questioncount,
	@ismultino
)  
select max(id) from votingquestion
go

ALTER  PROCEDURE VotingQuestion_Update (
	@id    int, 
	@votingid  int, 
	@subject   varchar(100), 
	@description   varchar(255), 
	@ismulti       int,
	@isother       int, 
        @ismultino     int,
	@flag integer output, 
	@msg varchar(80) output
) AS 
update votingquestion 
set 
	votingid=@votingid, 
	subject=@subject, 
	description=@description, 
	ismulti=@ismulti, 
	isother=@isother, 
	ismultino=@ismultino 
	where id=@id
go
