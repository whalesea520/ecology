alter table workflow_nodebase add nodeattribute char(1)
GO
update workflow_nodebase set nodeattribute='0'
GO
alter table workflow_nodebase add passnum int
GO
update workflow_nodebase set passnum=0
GO
alter table workflow_nodelink add ismustpass char(1)
GO
CREATE TABLE workflow_nownode(
    requestid int,
    nownodeid int,
    nownodetype int,
    nownodeattribute int
)
GO
insert into workflow_nownode select requestid,currentnodeid,currentnodetype,0 from workflow_requestbase
GO
alter table workflow_currentoperator add isreject char(1)
GO

alter PROCEDURE workflow_CurOpe_UpdatebySubmit 
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

update workflow_currentoperator set isremark = '2' where requestid =@requestid and isremark='0' and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2' where requestid =@requestid and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and  userid=@userid and nodeid=@nodeid

GO

alter PROCEDURE workflow_CurOpe_UpdatebyReject 
@requestid	int, 
@nodeid	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)

update workflow_currentoperator set isremark = '2',operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and isremark='0' and nodeid=@nodeid 

GO
