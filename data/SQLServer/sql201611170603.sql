select * into workflow_requestbase_dellog from workflow_requestbase where 1 = 2
GO
select * into workflow_curroperator_dellog from workflow_currentoperator where 1 = 2
GO
select * into workflow_requestLog_dellog from workflow_requestLog where 1 = 2
GO
select * into workflow_nownode_dellog from workflow_nownode where 1 = 2
GO
alter table workflow_requestdeletelog add deletetabledata text
GO
alter table workflow_requestdeletelog add isold char(1)
GO
update workflow_requestdeletelog set isold = '1'
GO
alter table workflow_requestdeletelog alter column CLIENT_ADDRESS varchar(50)
GO
alter table workflow_curroperator_dellog drop column id
GO
alter table workflow_curroperator_dellog add id integer
GO
alter table workflow_requestLog_dellog drop column logid
GO
alter table workflow_requestLog_dellog add logid integer
GO
