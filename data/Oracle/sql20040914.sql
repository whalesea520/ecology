/*数据库性能改进提交测试报告 */
/* 系统太不稳定，进行的系统优化中的脚本 */
CREATE or replace procedure workflow_currentoperator_SWf 
(
    userid_1		integer, 
    usertype_1	integer, 
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
as 
begin
  open thecursor for
  select count(distinct t1.requestid) workflowcount,t1.workflowid , t2.currentnodetype
  from workflow_currentoperator t1,workflow_requestbase t2 
  where t1.isremark in( '0','1') and t1.userid= userid_1 and t1.usertype= usertype_1 
  and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) 
  group by t1.workflowid , t2.currentnodetype order by t1.workflowid ;
end;
/


CREATE or replace procedure workflow_currentoperator_SWft 
(
    userid_1		integer,
    usertype_1	integer, 
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
as 
begin
    open thecursor for 
    select count(distinct t1.requestid) typecount,t1.workflowtype ,t2.currentnodetype 
    from workflow_currentoperator t1,workflow_requestbase t2 
    where t1.userid= userid_1  and t1.usertype= usertype_1 and t1.isremark in( '0','1') and
    t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) 
    group by t1.workflowtype , t2.currentnodetype ;
end;
/
