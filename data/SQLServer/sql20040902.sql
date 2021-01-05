/*td:738 修正默认流程的垃圾数据 */
insert into workflow_currentoperator(requestid,userid,groupid,workflowid,workflowtype,isremark,usertype) 
select  distinct requestid,creater,0,1,1,2,0 from workflow_requestbase where creatertype = 0 and deleted=0 and currentnodetype<>'3' and workflowid=1 
and requestid not in (
select  distinct t1.requestid from workflow_requestbase t1,workflow_currentoperator t2 where t1.requestid = t2.requestid and t2.usertype=0 and  t1.workflowid = 1  and t1.creater = t2.userid and t1.creatertype = 0 and (t1.deleted=0 or t1.deleted is null) and t1.currentnodetype <> 3 
) 
go