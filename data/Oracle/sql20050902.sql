CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I
( requestid1    integer, userid1        integer, groupid1    in out integer,
workflowid1    integer, workflowtype1    integer, usertype1    integer, isremark1    char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS
workflowtype2 integer;
begin 

if groupid1 is null 
then groupid1 := 0 ; 
end if ;

if workflowtype1 = '' 
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder); 
end if ;

end;
/
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
