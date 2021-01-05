alter table workflow_currentoperator 
add  groupdetailid int null
Go

alter table workflow_agentpersons
add  groupdetailid int null
Go

alter PROCEDURE workflow_CurrentOperator_I(
@requestid  int, @userid int, @groupid   int, @workflowid    int,
@workflowtype  int, @usertype  int, @isremark  char(1),
@nodeid  int,@agentorbyagentid  int,@agenttype  char(1),@showorder int, @groupdetailid int,
@flag integer output , @msg varchar(80) output)
AS
declare @workflowtype1 integer,
	@receivedate char(10),
    @receivetime char(8)

set @receivedate=convert(char(10),getdate(),20)
set @receivetime=convert(char(8),getdate(),108)

update workflow_currentoperator set islasttimes=0 where requestid=@requestid and userid=@userid and usertype = @usertype

if @workflowtype = ''
   begin
        select @workflowtype1 = workflowtype from workflow_base where id = @workflowid
        insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes,groupdetailid)
        values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype1,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,@receivedate,@receivetime,0,1,@groupdetailid)
   end
else
  begin
       insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes,groupdetailid)
       values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,@receivedate,@receivetime,0,1,@groupdetailid)
 end
 
go

alter PROCEDURE workflow_CurOpe_UpdatebySubmit 
@userid	int, 
@requestid	int, 
@groupid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark = '2'
where requestid =@requestid and isremark=0 and groupid =@groupid

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime  
where requestid =@requestid and userid=@userid and isremark=2 and groupid =@groupid

GO

INSERT INTO HtmlLabelIndex values(17416,'导出') 
GO
INSERT INTO HtmlLabelInfo VALUES(17416,'导出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17416,'Export',8) 
GO




