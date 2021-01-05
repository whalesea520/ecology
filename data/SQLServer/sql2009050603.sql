alter PROCEDURE workflow_CurrentOperator_Copy
(@requestid  	int, 
 @userid     	int,
 @usertype  	int, 
 @flag integer output , 
 @msg varchar(80) output) 
AS declare @operatedate char(10), @operatetime char(8)  
set @operatedate=convert(char(10),getdate(),20) 
set @operatetime=convert(char(8),getdate(),108)

update workflow_currentoperator 
set operatedate=@operatedate,operatetime=@operatetime
where requestid=@requestid and userid=@userid and usertype=@usertype and isremark = 8

update workflow_currentoperator 
set isremark=2
where requestid=@requestid and userid=@userid and usertype=@usertype

GO

