alter table workflow_createdoc add useTempletNode integer null
/
update workflow_createdoc set useTempletNode=-1
/