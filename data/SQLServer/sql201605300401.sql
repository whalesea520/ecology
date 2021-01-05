alter table mode_workflowtomodeset add triggerMethod int
go
alter table mode_workflowtomodeset add workflowExport int
go
alter table mode_workflowtomodeset add maintablewherecondition varchar(100)
go
alter table mode_workflowtomodesetopt add wherecondition varchar(100)
go