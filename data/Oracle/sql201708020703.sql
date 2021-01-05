alter table workflow_createdoc add onlyCanAddWord char(1)
/
update workflow_createdoc set onlyCanAddWord = '1' where onlyCanAddWord is null
/