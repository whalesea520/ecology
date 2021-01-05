CREATE or REPLACE PROCEDURE UpdateWFOperator

as
workflowid_1 integer;
workflowtype_1 integer;

begin
for all_cursor in 
(select id, workflowtype  from workflow_base)
loop
workflowid_1 :=all_cursor.id;
workflowtype_1:=all_cursor.workflowtype;
       update workflow_currentoperator set workflowtype = workflowtype_1 where workflowid = workflowid_1 and workflowtype != workflowtype_1;  
end loop;
end; 
/
call UpdateWFOperator()
/
drop PROCEDURE UpdateWFOperator
/
/*针对新建流程*/
CREATE INDEX WF_createrlist_IN
    ON workflow_createrlist(workflowid,USERID,USERTYPE)
/

CREATE INDEX WF_createrlist_IN2
    ON workflow_createrlist(USERID,USERTYPE)
/

/*针对代办适宜*/
CREATE INDEX WRKCUOPER_USER_IN2
    ON WORKFLOW_CURRENTOPERATOR(isremark,USERID,USERTYPE)
/

/*针对我的请求*/
CREATE INDEX WRKREQBASE_REQUEST_IN2
    ON WORKFLOW_REQUESTBASE(creater,creatertype)
/    

/*针对流程文档共享*/    
CREATE INDEX DOCSHARE_IN
    ON DocShare(docid,sharelevel)
/   
