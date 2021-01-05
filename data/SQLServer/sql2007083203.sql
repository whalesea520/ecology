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

update workflow_currentoperator set operatedate=@currentdate,operatetime=@currenttime,viewtype=-2 where requestid =@requestid and userid=@userid and isremark='0' and groupid =@groupid

update workflow_currentoperator set isremark = '2' where requestid =@requestid and isremark='0' and groupid =@groupid

GO
