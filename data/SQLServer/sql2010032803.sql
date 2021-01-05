alter PROCEDURE workflow_CurOpe_UbySubmitNB
@userid	int, 
@requestid	int, 
@groupid	int,
@nodeid	int,
@isremark char(1),
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @currentdate char(10),
	@currenttime char(8),
	@nodeAttribute char(1)

set @currentdate=convert(char(10),getdate(),20)
set @currenttime=convert(char(8),getdate(),108)


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
