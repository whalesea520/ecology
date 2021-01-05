alter table Workflow_SubwfSet add isread int default 0
go
update Workflow_SubwfSet set isread = 0
go
