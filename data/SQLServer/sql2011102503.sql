alter table workflow_requestbase add ismultiprint int default 0
go
update workflow_requestbase set ismultiprint=0
go