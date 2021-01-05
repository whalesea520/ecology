alter table workflow_createdoc add extfile2doc int null
GO
update workflow_createdoc set extfile2doc=1
GO
