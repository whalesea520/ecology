alter PROCEDURE workflow_CurOpe_UbyForward 
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

update workflow_currentoperator set isremark=2,operatedate=@currentdate,operatetime=@currenttime 
where requestid =@requestid and userid =@userid and usertype=@usertype and (isremark=1 or isremark=8 or isremark=9)
GO



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

update workflow_currentoperator set isremark = '2' where requestid =@requestid and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and  userid=@userid
GO