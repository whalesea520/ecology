alter table workflow_createdoc add documentTitleField int null
GO
update workflow_createdoc set documentTitleField=-1
GO
