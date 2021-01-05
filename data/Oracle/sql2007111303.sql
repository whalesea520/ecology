alter table workflow_createdoc add documentTitleField int null
/
update workflow_createdoc set documentTitleField=-1
/
