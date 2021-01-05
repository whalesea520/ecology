insert into workflowactionset(actionname,workflowid,nodeid,nodelinkid,ispreoperator,actionorder,interfacetype,typename,interfaceid,isused)
select mark,w_fid,w_nodeid,NODELINKID,ISPREOPERATOR,w_actionorder,4,'',mark,w_enable from int_browserbaseinfo where w_type=1 and mark not in (select actionname from workflowactionset)
GO



