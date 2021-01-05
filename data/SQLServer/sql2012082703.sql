alter table workflow_nodebase add operators_TEMP TEXT
go
update workflow_nodebase set operators_TEMP = operators
go
EXEC sp_rename 'workflow_nodebase.[operators]', 'operators_1', 'COLUMN '
go
EXEC sp_rename 'workflow_nodebase.[operators_TEMP]', 'operators', 'COLUMN '
go