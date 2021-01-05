alter PROCEDURE workflow_CurOpe_UbySubmitNB
@userid	int, 
@requestid	int, 
@groupid	int,
@nodeid	int,
@isremark char(1),
@currentdate char(10),
@currenttime char(8),
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @nodeAttribute char(1)

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime,viewtype=-2, needwfback='0' where requestid =@requestid and userid=@userid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =@requestid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

select @nodeAttribute=nodeAttribute from workflow_nodebase where id =@nodeid
if @nodeAttribute is null set @nodeAttribute=0
if @nodeAttribute=2 
    begin
        update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =@requestid and (isremark='5' or isremark='8' or isremark='9') and  userid=@userid and nodeid=@nodeid
    end
else 
    begin
        update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =@requestid and (isremark='5' or isremark='8' or isremark='9') and  userid=@userid
    end    


GO

alter PROCEDURE workflow_CurOpe_UpdatebySubmit 
@userid	int, 
@requestid	int, 
@groupid	int,
@nodeid	int,
@isremark char(1),
@currentdate char(10),
@currenttime char(8),
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
DECLARE @nodeAttribute char(1)

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime,viewtype=-2 where requestid =@requestid and userid=@userid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

update workflow_currentoperator set isremark = '2' where requestid =@requestid and isremark=@isremark and groupid =@groupid and nodeid=@nodeid

select @nodeAttribute=nodeAttribute from workflow_nodebase where id =@nodeid
if @nodeAttribute is null set @nodeAttribute=0
if @nodeAttribute=2 
    begin
        update workflow_currentoperator set isremark = '2' where requestid =@requestid and (isremark='5' or isremark='8' or isremark='9') and  userid=@userid and nodeid=@nodeid
    end
else 
    begin
        update workflow_currentoperator set isremark = '2' where requestid =@requestid and (isremark='5' or isremark='8' or isremark='9') and  userid=@userid
    end    
GO