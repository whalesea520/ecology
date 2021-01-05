ALTER table  hpNewsTabInfo  Add sqlWhere_1 varchar2(4000)
/
update  hpNewsTabInfo set sqlWhere_1 = sqlWhere
/
ALTER table  hpNewsTabInfo  drop column sqlWhere
/
ALTER TABLE hpNewsTabInfo RENAME COLUMN sqlWhere_1 TO sqlWhere
/
