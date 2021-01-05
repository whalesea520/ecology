CREATE procedure wrkcrt_mutidel
(@flag integer output,
 @msg varchar(80) output
 )
as
declare @requestid_1 integer,@userid_1 integer,@isremark_1 integer,
@groupid_1 integer,@workflowid_1 integer,@workflowtype_1 integer

delete from workflow_requestViewLog where (convert(varchar(10),id)+','+convert(varchar(10),currentnodeid)) in 
( select (convert(varchar(10),a.id)+','+convert(varchar(10),a.currentnodeid)) from 
  workflow_requestViewLog a, workflow_requestbase b
  where a.currentnodeid != b.currentnodeid and a.id = b.requestid ) 

delete from workflow_currentoperator where userid in (select id from hrmresource where 
loginid is null or loginid='') and usertype = 0 

delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null or loginid='') and usertype = 1

declare all_cursor cursor for 
(select requestid, userid , min(convert(int,isremark)) isremark from workflow_currentoperator 
group by requestid, userid having count(requestid) > 1  )
open all_cursor 
fetch next from all_cursor into @requestid_1,@userid_1,@isremark_1
while @@fetch_status=0 
begin 
    select @groupid_1=min(groupid) , @workflowid_1=min(workflowid) ,@workflowtype_1=min(workflowtype) 
    from workflow_currentoperator  
    where requestid = @requestid_1 and  userid = @userid_1 and convert(int,isremark) = @isremark_1  

    delete workflow_currentoperator where  requestid = @requestid_1 and  userid = @userid_1  

    insert into workflow_currentoperator (requestid,userid,usertype,isremark,groupid,workflowid,workflowtype) 
	values (@requestid_1 , @userid_1 , 0 , convert(int,@isremark_1),@groupid_1 ,@workflowid_1, @workflowtype_1)    
    fetch next from all_cursor into @requestid_1,@userid_1,@isremark_1
end 
close all_cursor 
deallocate all_cursor 
GO

drop  INDEX workflow_currentoperator.wrkcuoper_requestid_in 
GO

drop  INDEX workflow_currentoperator.wrkcuoper_user_in 
GO

create NONCLUSTERED INDEX wrkcuoper_requestid_in on workflow_currentoperator(requestid,userid,usertype) 
GO
UPDATE license set cversion = '2.642' 
go