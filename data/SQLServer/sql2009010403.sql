alter table workflow_base add ShowDelButtonByReject char(1)
GO
update workflow_base set ShowDelButtonByReject='1'
GO
