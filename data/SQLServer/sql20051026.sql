ALTER TABLE workflow_currentoperator ADD 
receivedate char(10),
receivetime char(8),
viewtype int,
orderdate char(10),
ordertime char(8),
iscomplete int,
islasttimes int
GO 

INSERT INTO HtmlLabelIndex values(17991,'已办事宜') 
GO
INSERT INTO HtmlLabelIndex values(17992,'办结事宜') 
GO
INSERT INTO HtmlLabelInfo VALUES(17991,'已办事宜',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17991,'handled matters',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17992,'办结事宜',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17992,'complete matters',8) 
GO
INSERT INTO HtmlLabelIndex values(17994,'接收日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(17994,'接收日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17994,'receive date',8) 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,1,3
GO
EXECUTE LMInfo_Insert 90,17991,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_6.gif','/workflow/request/RequestHandled.jsp',2,1,3,3 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,1,4
GO
EXECUTE LMInfo_Insert 91,17992,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_8.gif','/workflow/request/RequestComplete.jsp',2,1,4,3 
GO

update workflow_currentoperator set viewtype=-2
GO
update workflow_currentoperator set iscomplete=0 where requestid in(select requestid from workflow_requestbase where currentnodetype<>3)
GO
update workflow_currentoperator set iscomplete=1 where requestid in(select requestid from workflow_requestbase where currentnodetype=3)
GO
update workflow_currentoperator set islasttimes=1 where isremark=0 or isremark=1 or isremark=4
GO
update workflow_currentoperator set islasttimes=0 where isremark=2
GO
update workflow_currentoperator set receivedate='2005-10-31',receivetime='01:01:01',orderdate='2005-10-31',ordertime='01:01:01'  
where receivedate is null and receivetime is null
GO
alter PROCEDURE workflow_CurrentOperator_I
@requestid  int, @userid int, @groupid   int, @workflowid    int,
@workflowtype  int, @usertype  int, @isremark  char(1),
@nodeid  int,@agentorbyagentid  int,@agenttype  char(1),@showorder int,
@flag integer output , @msg varchar(80) output
AS
declare @workflowtype1 integer,
	@receivedate char(10),
	@receivetime char(8)

set @receivedate=convert(char(10),getdate(),20)
set @receivetime=convert(char(8),getdate(),108)

update workflow_currentoperator set islasttimes=0 where requestid=@requestid and userid=@userid;

if @workflowtype = ''
   begin
        select @workflowtype1 = workflowtype from workflow_base where id = @workflowid
        insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
        values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype1,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,@receivedate,@receivetime,0,1)
   end
else
  begin
       insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
       values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,@receivedate,@receivetime,0,1)
 end
 
go
