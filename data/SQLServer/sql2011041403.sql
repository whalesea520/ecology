alter table workflow_nodelink add tempcol varchar(4000)
go
update workflow_nodelink set tempcol = condition
go
alter table workflow_nodelink drop column condition
go
alter table workflow_nodelink add condition text DEFAULT ''
go
update workflow_nodelink set condition = tempcol
go

update workflow_nodelink set tempcol = conditioncn
go
alter table workflow_nodelink drop column conditioncn
go
alter table workflow_nodelink add conditioncn text DEFAULT ''
go
update workflow_nodelink set conditioncn = tempcol
go
alter table workflow_nodelink drop column tempcol
go
