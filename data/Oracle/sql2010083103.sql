ALTER table  hpElement  Add title_1 varchar2(100)
/
update  hpElement set title_1 = title
/
ALTER table  hpElement  drop column title
/
ALTER TABLE hpElement RENAME COLUMN title_1 TO title
/
