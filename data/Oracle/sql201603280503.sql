create table workflow_flownode_dellog as select * from workflow_flownode where 1 = 2
/
alter table workflow_flownode_dellog add deletedate varchar2(10)
/
alter table workflow_flownode_dellog add deletetime varchar2(8)
/
alter table workflow_flownode_dellog add deleteoperator Integer
/
create index index_workflow_flownode_dellog on workflow_flownode_dellog(nodeid)
/