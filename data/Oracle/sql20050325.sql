/*真正删除所有原来用户删除的请求*/
delete workflow_currentoperator where requestid in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_form where requestid in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_requestLog where requestid in (select requestid from workflow_requestbase where deleted=1 ) 
/
delete workflow_requestViewLog where id in (select requestid from workflow_requestbase where deleted=1) 
/
delete workflow_requestbase where deleted=1
/



/*处理掉归档的操作人状态，改为4即代表操作人能查看的流程是规档的*/
update  workflow_currentoperator  set isremark='4'  where  requestid in (select requestid  from workflow_requestbase where currentnodetype = '3' )
/
