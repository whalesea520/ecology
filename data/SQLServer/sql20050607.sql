create PROCEDURE UpdateWFOperator
as
declare @workflowid_1 int, @workflowtype_1 int

declare all_cursor cursor for 
(select id, workflowtype  from workflow_base)
open all_cursor 
fetch next from all_cursor into @workflowid_1 , @workflowtype_1
while @@fetch_status=0 
begin     
    
    update workflow_currentoperator set workflowtype = @workflowtype_1 where workflowid = @workflowid_1 and workflowtype != @workflowtype_1  

    fetch next from all_cursor into  @workflowid_1 , @workflowtype_1
end 
close all_cursor 
deallocate all_cursor 
GO

exec UpdateWFOperator
go

drop PROCEDURE UpdateWFOperator
go
/*针对新建流程*/
CREATE INDEX WF_createrlist_IN
    ON workflow_createrlist(workflowid,USERID,USERTYPE)
go

CREATE INDEX WF_createrlist_IN2
    ON workflow_createrlist(USERID,USERTYPE)
go

/*针对代办适宜*/
CREATE INDEX WRKCUOPER_USER_IN2
    ON WORKFLOW_CURRENTOPERATOR(isremark,USERID,USERTYPE)
go

/*针对我的请求*/
CREATE INDEX WRKREQBASE_REQUEST_IN2
    ON WORKFLOW_REQUESTBASE(creater,creatertype)
go    

/*针对流程文档共享*/    
CREATE INDEX DOCSHARE_IN
    ON DocShare(docid,sharelevel)
go   
