ALTER TABLE  workflow_nodecustomrcmenu add subnobackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add subnobackName8 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add subbackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add subbackName8 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add forsubnobackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add forsubnobackName8 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add forsubbackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add forsubbackName8 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add ccsubnobackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add ccsubnobackName8 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add ccsubbackName7 varchar(50) null
GO
ALTER TABLE  workflow_nodecustomrcmenu add ccsubbackName8 varchar(50) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasfornoback char(1) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasforback char(1) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasccnoback char(1) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasccback char(1) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasnoback char(1) null
GO
ALTER TABLE workflow_nodecustomrcmenu add hasback char(1) null
GO
update workflow_nodecustomrcmenu set subbackName7 = submitName7, hasback='1' where submitName7 is not null and submitName7 <> ''
GO
update workflow_nodecustomrcmenu set subbackName8 = submitName8, hasback='1' where submitName8 is not null and submitName8 <> ''
GO
update workflow_nodecustomrcmenu set forsubbackName7 = forsubName7, hasforback='1' where forsubName7 is not null and forsubName7 <> ''
GO
update workflow_nodecustomrcmenu set forsubbackName8 = forsubName8, hasforback='1' where forsubName8 is not null and forsubName8 <> ''
GO
update workflow_nodecustomrcmenu set ccsubbackName7 = ccsubName7, hasccback='1' where ccsubName7 is not null and ccsubName7 <> ''
GO
update workflow_nodecustomrcmenu set ccsubbackName8 = ccsubName8, hasccback='1' where ccsubName8 is not null and ccsubName8 <> ''
GO
alter table workflow_currentoperator add needwfback char(1) null
GO
update workflow_currentoperator set needwfback='1'
GO


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
        insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,preisremark,needwfback)
        values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype1,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,0,1,@groupdetailid,@isremark,'1')
   end
else
  begin
       insert into workflow_currentoperator(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,preisremark,needwfback)
       values
       (@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder,@receivedate,@receivetime,0,0,1,@groupdetailid,@isremark,'1')
 end
 
go

CREATE PROCEDURE workflow_CurOpe_UbySubmitNB
@userid	int, 
@requestid	int, 
@groupid	int,
@nodeid	int,
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime,viewtype=-2 where requestid =@requestid and userid=@userid and isremark='0' and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =@requestid and isremark='0' and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =@requestid and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and  userid=@userid 

GO

CREATE PROCEDURE workflow_CurOpe_UbyForwardNB
@requestid	int, 
@userid		int, 
@usertype	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark=2,operatedate=@currentdate,operatetime=@currenttime, needwfback='0'
where requestid =@requestid and userid =@userid and usertype=@usertype and (isremark=1 or isremark=8 or isremark=9)

GO

CREATE PROCEDURE workflow_CurOpe_UbySendNB
	@requestid	integer, 
	@userid		integer, 
	@usertype	integer, 
	@flag 		integer 	output , 
	@msg 		varchar(80) 	output 
AS declare 
	@currentdate char(10), 
	@currenttime char(8)  
	set @currentdate=convert(char(10),getdate(),20) 
	set @currenttime=convert(char(8),getdate(),108)  
update workflow_currentoperator 
set isremark=2,operatedate=@currentdate,operatetime=@currenttime,needwfback='0'
where requestid =@requestid and userid =@userid and usertype=@usertype and isremark=9
GO 

CREATE PROCEDURE workflow_CurOpe_UpdatebyPassNB
@requestid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output AS 

declare 
@currentdate char(10), 
@currenttime char(8)  
set @currentdate=convert(char(10),getdate(),20) 
set @currenttime=convert(char(8),getdate(),108)  

update workflow_currentoperator 
set isremark = '2',operatedate=@currentdate,operatetime=@currenttime, needwfback='0'
where requestid =@requestid and isremark=0 

GO