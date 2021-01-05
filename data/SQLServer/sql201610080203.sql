alter  view workflowactionview as
select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 0 as actiontype,isused from workflowactionset d where d.interfacetype=1 union select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 1 as actiontype,isused from workflowactionset d where d.interfacetype=2 
union 
select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 3 as actiontype,isused from workflowactionset d where d.interfacetype=3 
union 
select d.interfaceid as id, d.actionname, d.actionorder, d.nodeid, d.workflowId, d.nodelinkid, d.ispreoperator, 4 as actiontype,isused from workflowactionset d where d.interfacetype=4 
union 
select convert(varchar,s.id) as id, s.actionname, s.actionorder, s.nodeid, s.workflowId, s.nodelinkid, s.ispreoperator, 2 as actiontype,1 as isused from sapactionset s
GO