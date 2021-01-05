select * into workflow_flownode_dellog from workflow_flownode where 1 = 2
GO
alter table workflow_flownode_dellog add deletedate varchar(10)
GO
alter table workflow_flownode_dellog add deletetime varchar(8)
GO
alter table workflow_flownode_dellog add deleteoperator int
GO
create index index_workflow_flownode_dellog on workflow_flownode_dellog(nodeid)
GO