ALTER PROCEDURE wrkcrt_mutidel
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

delete from workflow_currentoperator where userid in (select id from hrmresource where 
loginid is null or loginid='') and usertype = 0 

delete from DocShareDetail where userid in(select id from hrmresource where 
loginid is null or loginid='') and usertype = 1

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
GO



/*真正删除所有原来用户删除的请求*/
delete workflow_currentoperator where requestid in (select requestid from workflow_requestbase where deleted=1) 
GO
delete workflow_form where requestid in (select requestid from workflow_requestbase where deleted=1) 
GO
delete workflow_requestLog where requestid in (select requestid from workflow_requestbase where deleted=1 ) 
GO
delete workflow_requestViewLog where id in (select requestid from workflow_requestbase where deleted=1) 
GO
delete workflow_requestbase where deleted=1
GO



/*处理掉归档的操作人状态，改为4即代表操作人能查看的流程是规档的,历史操作人的isremark='2'记录保留*/
update  workflow_currentoperator  set isremark='4'  
where  requestid in (select requestid  from workflow_requestbase where currentnodetype = '3' )
and isremark='0'
GO

/*删除掉在workflow_currentoperator中有但在workflow_requestbase里没有的requestid，在转换为oracle时请慎重*/
delete workflow_currentoperator where requestid in (select t2.requestid
from  workflow_requestbase t1 right join workflow_currentoperator t2 on t1.requestid=t2.requestid
where t1.requestid is null)
GO
