alter PROCEDURE workflow_CurrentOperator_I @requestid  int, @userid        int, @groupid   int, @workflowid    int,
@workflowtype  int, @usertype  int, @isremark  char(1),@nodeid  int,@agentorbyagentid  int,@agenttype  char(1),@showorder int,
@flag integer output , @msg varchar(80) output
AS insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder)
values(@requestid,@userid,@groupid, @workflowid,@workflowtype,@usertype,@isremark,@nodeid,@agentorbyagentid,@agenttype,@showorder)
GO


alter PROCEDURE  workflow_RequestLog_Insert @requestid int, @workflowid    int, @nodeid    int, @logtype   char(1), @operatedate   char(10), @operatetime  char(8), @operator  int,
@remark    text, @clientip char(15), @operatortype int, @destnodeid    int, @operate varchar(1000),
@agentorbyagentid  int,@agenttype  char(1),@showorder int, @flag integer output , @msg varchar(80) output
AS declare @count integer
if @logtype = '1'
  begin
    select @count = count(*) from workflow_requestlog where requestid=@requestid and nodeid=@nodeid and logtype=@logtype and operator = @operator and operatortype = @operatortype
    if @count > 0
       begin
         update workflow_requestlog SET   [operatedate]   = @operatedate, [operatetime]   = @operatetime, [remark]    = @remark, [clientip]   = @clientip, [destnodeid]   = @destnodeid
         WHERE ( [requestid]  = @requestid AND [nodeid]   = @nodeid AND [logtype]    = @logtype AND [operator]   = @operator AND [operatortype]  = @operatortype)
       end
    else
       begin
         insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder)
       end
  end
else
    begin
      delete workflow_requestlog where requestid=@requestid and nodeid=@nodeid and (logtype='1') and operator = @operator and operatortype = @operatortype
      insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder) values(@requestid,@workflowid,@nodeid,@logtype, @operatedate,@operatetime,@operator, @remark,@clientip,@operatortype,@destnodeid,@operate,@agentorbyagentid,@agenttype,@showorder)
    end
GO


alter PROCEDURE workflow_RequestViewLog_Insert @id	int, @viewer	int,
@viewdate	char(10), @viewtime	char(8), @clientip	char(15),
@viewtype 	int, @currentnodeid	int,@ordertype char(1),@showorder int,
@flag integer output ,@msg varchar(80) output
AS insert into workflow_requestviewlog (id,viewer, viewdate,viewtime,ipaddress,viewtype,currentnodeid,ordertype,showorder)
values(@id,@viewer, @viewdate,@viewtime,@clientip,@viewtype,@currentnodeid,@ordertype,@showorder)
GO


alter PROCEDURE workflow_groupdetail_SByGroup (@id     [int], @flag    [int]   output, @msg    [varchar](80)   output)
AS
SELECT * FROM [workflow_groupdetail] WHERE ( [groupid]    = @id) order by id asc set @flag = 1 set @msg = 'OK!'
GO

alter PROCEDURE wrkcrt_mutidel
(@flag integer output,
 @msg varchar(80) output
 )
as
declare @requestid_1 integer,@userid_1 integer,@isremark_1 integer,@isremark_2 integer,
@groupid_1 integer,@workflowid_1 integer,@workflowtype_1 integer

delete from workflow_requestViewLog where (convert(varchar(10),id)+','+convert(varchar(10),currentnodeid)) in 
( select (convert(varchar(10),a.id)+','+convert(varchar(10),a.currentnodeid)) from 
  workflow_requestViewLog a, workflow_requestbase b
  where a.currentnodeid != b.currentnodeid and a.id = b.requestid ) 
/*
delete from workflow_currentoperator where userid in (select id from hrmresource where 
loginid is null or loginid='') and usertype = 0 
*/
delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null or loginid='') and usertype = 1
/*
declare all_cursor cursor for 
(select requestid, userid ,usertype , min(convert(int,isremark)) isremark ,max(convert(int,isremark)) maxisremark from workflow_currentoperator 
group by requestid, userid ,usertype having count(requestid) > 1  )
open all_cursor 
fetch next from all_cursor into @requestid_1,@userid_1,@isremark_1,@isremark_2
while @@fetch_status=0 
begin 
    select @groupid_1=min(groupid) , @workflowid_1=min(workflowid) ,@workflowtype_1=min(workflowtype) 
    from workflow_currentoperator  
    where requestid = @requestid_1 and  userid = @userid_1 and convert(int,isremark) = @isremark_1  

    delete workflow_currentoperator where  requestid = @requestid_1 and  userid = @userid_1 and isremark<>4 

    if(@isremark_2<4)
    insert into workflow_currentoperator (requestid,userid,usertype,isremark,groupid,workflowid,workflowtype) 
	values (@requestid_1 , @userid_1 , 0 , convert(int,@isremark_1),@groupid_1 ,@workflowid_1, @workflowtype_1)    

    fetch next from all_cursor into @requestid_1,@userid_1,@isremark_1
end 
close all_cursor 
deallocate all_cursor 
*/
GO
