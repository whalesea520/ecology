alter PROCEDURE workflow_CurrentOperator_Copy
(@requestid  	int, 
 @userid     	int,
 @usertype  	int, 
 @flag integer output , 
 @msg varchar(80) output) 
AS declare @operatedate char(10), @operatetime char(8)  ,@isremark char(1),@nodetype char(1)
set @operatedate=convert(char(10),getdate(),20) 
set @operatetime=convert(char(8),getdate(),108)
set @isremark='2'
select @nodetype=currentnodetype from workflow_requestbase where requestid= @requestid
if @nodetype is null  set @nodetype='0'
if @nodetype='3'  set @isremark='4'

update workflow_currentoperator 
set isremark=@isremark,operatedate=@operatedate,operatetime=@operatetime
where requestid=@requestid and userid=@userid and usertype=@usertype and isremark = '8'

GO
