alter table workflow_createdoc add useTempletNode int null
GO
update workflow_createdoc set useTempletNode=-1
GO