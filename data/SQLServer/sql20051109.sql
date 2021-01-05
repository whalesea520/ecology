
CREATE TABLE workflow_currentoperator_tmp (
	requestid 	int NOT NULL ,
	userid 		int NULL ,
	groupid 	int NULL ,
	workflowid 	int NULL ,
	workflowtype 	int NULL ,
	isremark 	char (1)  NULL ,
	usertype 	int NULL ,
	nodeid		int NULL ,
	agentorbyagentid	int NULL ,
	agenttype	char (1)  NULL ,
	showorder	int NULL ,
	receivedate	char (10)  NULL ,
	receivetime	char (8)  NULL ,
	viewtype	int NULL ,
	orderdate	char (10)  NULL ,
	ordertime	char (8)  NULL ,
	iscomplete	int NULL ,
	islasttimes	int NULL 
)
GO

INSERT INTO workflow_currentoperator_tmp(
requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes)
SELECT requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes
FROM workflow_currentoperator ORDER BY requestid,nodeid
GO

DROP TABLE workflow_currentoperator
GO

CREATE TABLE dbo.workflow_currentoperator (
	requestid 	int NOT NULL ,
	userid 		int NULL ,
	groupid 	int NULL ,
	workflowid 	int NULL ,
	workflowtype 	int NULL ,
	isremark 	char (1)  NULL ,
	usertype 	int NULL ,
	nodeid		int NULL ,
	agentorbyagentid	int NULL ,
	agenttype	char (1)  NULL ,
	showorder	int 	NULL ,
	receivedate	char (10)  NULL ,
	receivetime	char (8)  NULL ,
	viewtype	int NULL ,
	orderdate	char (10)  NULL ,
	ordertime	char (8)  NULL ,
	iscomplete	int NULL ,
	islasttimes	int NULL ,
	id		int IDENTITY (1, 1) NOT NULL
)
GO

INSERT INTO workflow_currentoperator(
requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes)
SELECT requestid ,userid ,groupid ,workflowid ,workflowtype ,isremark ,usertype ,nodeid ,agentorbyagentid ,agenttype ,
showorder ,receivedate ,receivetime ,viewtype ,orderdate ,ordertime ,iscomplete ,islasttimes
FROM workflow_currentoperator_tmp ORDER BY requestid,nodeid
GO

CREATE NONCLUSTERED INDEX wrkcuoper_requestid_in on workflow_currentoperator(requestid,userid,usertype) 
GO
CREATE INDEX WRKCUOPER_USER_IN2
    ON WORKFLOW_CURRENTOPERATOR(isremark,USERID,USERTYPE)
GO

DROP TABLE workflow_currentoperator_tmp
GO



declare c1 cursor for select id,workflowtype from workflow_base
open c1 
declare  @wfid int
declare  @wftype int 
fetch next from c1 into @wfid, @wftype
while @@fetch_status=0 begin 
	update workflow_currentoperator set workflowtype=@wftype where workflowid=@wfid and workflowtype<>@wftype
	fetch next from c1 into @wfid, @wftype
end 
close c1 deallocate c1 
GO

update workflow_currentoperator set islasttimes=1
GO

declare c_4 cursor for 
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where isremark=4
	group by requestid,userid
	having count(*)>0
	order by requestid,userid
open c_4
declare  @requestid_4 int
declare  @userid_4 int 
declare  @maxid_4 int
declare  @tcount_4 int 
fetch next from c_4 into @requestid_4,@userid_4,@maxid_4,@tcount_4
while @@fetch_status=0 begin 
	update workflow_currentoperator set islasttimes=0 where requestid=@requestid_4 and userid=@userid_4 and isremark<4
	if @tcount_4>1 
		update workflow_currentoperator set islasttimes=0 where requestid=@requestid_4 and userid=@userid_4 and isremark=4 and id<@maxid_4
	fetch next from c_4 into @requestid_4,@userid_4,@maxid_4,@tcount_4
end 
close c_4 deallocate c_4 
GO

declare c_0 cursor for 
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=0
	group by requestid,userid
	having count(*)>0
	order by requestid,userid
open c_0
declare  @requestid_0 int
declare  @userid_0 int 
declare  @maxid_0 int
declare  @tcount_0 int 
fetch next from c_0 into @requestid_0,@userid_0,@maxid_0,@tcount_0
while @@fetch_status=0 begin 
	update workflow_currentoperator set islasttimes=0 where requestid=@requestid_0 and userid=@userid_0 and isremark in (1,2)
	if @tcount_0>1 
		update workflow_currentoperator set islasttimes=0 where requestid=@requestid_0 and userid=@userid_0 and isremark=0 and id<@maxid_0
	fetch next from c_0 into @requestid_0,@userid_0,@maxid_0,@tcount_0
end 
close c_0 deallocate c_0 
GO

declare c_1 cursor for 
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=1
	group by requestid,userid
	having count(*)>0
	order by requestid,userid
open c_1
declare  @requestid_1 int
declare  @userid_1 int 
declare  @maxid_1 int
declare  @tcount_1 int 
fetch next from c_1 into @requestid_1,@userid_1,@maxid_1,@tcount_1
while @@fetch_status=0 begin 
	update workflow_currentoperator set islasttimes=0 where requestid=@requestid_1 and userid=@userid_1 and isremark=2
	if @tcount_1>1 
		update workflow_currentoperator set islasttimes=0 where requestid=@requestid_1 and userid=@userid_1 and isremark=1 and id<@maxid_1
	fetch next from c_1 into @requestid_1,@userid_1,@maxid_1,@tcount_1
end 
close c_1 deallocate c_1 
GO

declare c_2 cursor for 
	select requestid,userid,max(id) maxid,count(*) tcount
	from workflow_currentoperator
	where islasttimes=1 and isremark=2
	group by requestid,userid
	having count(*)>0
	order by requestid,userid
open c_2
declare  @requestid_2 int
declare  @userid_2 int 
declare  @maxid_2 int
declare  @tcount_2 int 
fetch next from c_2 into @requestid_2,@userid_2,@maxid_2,@tcount_2
while @@fetch_status=0 begin 
	if @tcount_2>1 
		update workflow_currentoperator set islasttimes=0 where requestid=@requestid_2 and userid=@userid_2 and isremark=2 and id<@maxid_2
	fetch next from c_2 into @requestid_2,@userid_2,@maxid_2,@tcount_2
end 
close c_2 deallocate c_2 
GO



update workflow_currentoperator set viewtype=-2 where viewtype is null or viewtype>0
GO



update workflow_currentoperator set iscomplete=0 where requestid in(select requestid from workflow_requestbase where currentnodetype<>3) and iscomplete<>0
GO
update workflow_currentoperator set iscomplete=1 where requestid in(select requestid from workflow_requestbase where currentnodetype=3) and iscomplete<>1
GO


ALTER PROCEDURE workflow_Requestbase_Insert 
@requestid	int, @workflowid	int, @lastnodeid	int, 
@lastnodetype	char(1), @currentnodeid	int, @currentnodetype	char(1), 
@status		varchar(50), @passedgroups	int, @totalgroups	int, 
@requestname	varchar(255), @creater	int, @createdate	char(10), 
@createtime	char(8), @lastoperator	int, @lastoperatedate	char(10), 
@lastoperatetime	char(8), @deleted	int, @creatertype	int, 
@lastoperatortype	int, @nodepasstime	float, @nodelefttime	float, 
@docids 		[text], @crmids 		[text], 
@hrmids 		[text], @prjids 		[text], 
@cptids 		[text], @messageType 	int, 
@flag integer output , @msg varchar(80) output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

insert into workflow_requestbase 
(requestid,workflowid,lastnodeid,lastnodetype, currentnodeid,currentnodetype,status, 
passedgroups,totalgroups,requestname,creater,createdate,createtime,lastoperator, 
lastoperatedate,lastoperatetime,deleted,creatertype,lastoperatortype,nodepasstime,
nodelefttime,docids,crmids,hrmids,prjids,cptids,messageType) 
values
(@requestid,@workflowid,@lastnodeid,@lastnodetype, @currentnodeid,@currentnodetype,@status, 
@passedgroups,@totalgroups,@requestname,@creater,@currentdate,@currenttime,@lastoperator, 
@lastoperatedate,@lastoperatetime,@deleted,@creatertype,@lastoperatortype,@nodepasstime,
@nodelefttime,@docids,@crmids,@hrmids,@prjids,@cptids,@messageType)

GO

