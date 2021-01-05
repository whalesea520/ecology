alter table workflow_createdoc add onlyCanAddWord VARCHAR(1)
GO
update workflow_createdoc set onlyCanAddWord = '1' where onlyCanAddWord is null
GO