delete from workflow_NodeFormGroup where nodeid in(select distinct b.nodeid from workflow_base a,workflow_flownode b where a.id=b.workflowid and a.ISBILL='1' and a.FORMID in(156,157,158)) 
GO
insert into workflow_NodeFormGroup(nodeid,groupid,isadd,isedit,isdelete) select distinct b.nodeid,0,'1','1','1' from workflow_base a,workflow_flownode b where a.id=b.workflowid and a.ISBILL='1' and a.FORMID in(156,157,158) and b.nodetype ='0'
GO
insert into workflow_NodeFormGroup(nodeid,groupid,isadd,isedit,isdelete) select distinct b.nodeid,0,'0','1','0' from workflow_base a,workflow_flownode b where a.id=b.workflowid and a.ISBILL='1' and a.FORMID in(156,157,158) and b.nodetype in('1','2')
GO