alter table workflow_NodeFormGroup add  defaultrows int default 0
GO

alter table workflow_nodelink add  dateField varchar(200)
GO
alter table workflow_nodelink add  timeField varchar(200)
GO