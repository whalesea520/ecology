alter PROCEDURE 
workflow_Requestbase_Insert 
@requestid	int, 
@workflowid	int, 
@lastnodeid	int, 
@lastnodetype	char(1), 
@currentnodeid	int, 
@currentnodetype	char(1), 
@status		varchar(50), 
@passedgroups	int, 
@totalgroups	int, 
@requestname	varchar(255), 
@creater	int, 
@createdate	char(10), 
@createtime	char(8), 
@lastoperator	int, 
@lastoperatedate	char(10), 
@lastoperatetime	char(8), 
@deleted	int, @creatertype	int, 
@lastoperatortype	int, 
@nodepasstime	float, 
@nodelefttime	float, 
@docids 		[text], 
@crmids 		[text], 
@hrmids 		[text], 
@prjids 		[text], 
@cptids 		[text], @flag integer output , @msg varchar(80) output 
AS 
insert into workflow_requestbase (requestid,workflowid,lastnodeid,lastnodetype, currentnodeid,currentnodetype,status, passedgroups,totalgroups,requestname,creater,createdate,createtime,lastoperator, lastoperatedate,lastoperatetime,deleted,creatertype,lastoperatortype,nodepasstime,nodelefttime,docids,crmids,hrmids,prjids,cptids) values(@requestid,@workflowid,@lastnodeid,@lastnodetype, @currentnodeid,@currentnodetype,@status, @passedgroups,@totalgroups,@requestname,@creater,@createdate,@createtime,@lastoperator, @lastoperatedate,@lastoperatetime,@deleted,@creatertype,@lastoperatortype,@nodepasstime,@nodelefttime,@docids,@crmids,@hrmids,@prjids,@cptids) 
GO
UPDATE license set cversion = '2.621'
go