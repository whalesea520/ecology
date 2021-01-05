CREATE OR REPLACE PROCEDURE workflow_requestbase_MyRequest 
	(userid_1  integer,
    usertype_2    integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin

open thecursor for
select count(distinct t1.requestid) typecount,t2.workflowtype ,t1.workflowid,t1.currentnodetype
from workflow_requestbase t1, workflow_base t2 
where t1.creater = userid_1 and t1.creatertype=usertype_2 
and t1.workflowid=t2.id and t2.isvalid='1' and exists (select 1 from workflow_currentoperator where workflow_currentoperator.requestid=t1.requestid) group by t2.workflowtype,t1.workflowid,t1.currentnodetype;
end;
/