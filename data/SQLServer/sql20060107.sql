alter table workflow_base add docCategory1 varchar(200)
go
update workflow_base set docCategory1=docCategory
go
alter table workflow_base drop column docCategory
go
alter table workflow_base add docCategory varchar(200)
go
update workflow_base set docCategory=docCategory1
go
alter table workflow_base drop column docCategory1
go