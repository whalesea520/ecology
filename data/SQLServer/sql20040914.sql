/*数据库性能改进提交测试报告 */
/* 系统太不稳定，进行的系统优化中的脚本 */
alter PROCEDURE workflow_currentoperator_SWf 
  @userid		int, 
  @usertype	int, 
  @flag integer output , 
  @msg varchar(80) output  
  as 
  select count( distinct t1.requestid) workflowcount,t1.workflowid , t2.currentnodetype 
  from workflow_currentoperator t1,workflow_requestbase t2 
  where t1.isremark in( '0','1') and t1.userid=@userid and t1.usertype=@usertype 
  and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) 
  group by t1.workflowid , t2.currentnodetype order by t1.workflowid
GO

alter PROCEDURE workflow_currentoperator_SWft 
  @userid		int,
  @usertype	int, 
  @flag integer output ,
  @msg varchar(80) output  
    as 
    select count(distinct t1.requestid) typecount,t1.workflowtype , t2.currentnodetype 
    from workflow_currentoperator t1,workflow_requestbase t2 
    where t1.userid=@userid  and t1.usertype=@usertype and t1.isremark in( '0','1') 
    and t1.requestid=t2.requestid and ( t2.deleted=0 or t2.deleted is null ) 
    group by t1.workflowtype , t2.currentnodetype 
GO