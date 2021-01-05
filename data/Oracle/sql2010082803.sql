ALTER table  hpElement  Add strsqlwhere_1 varchar2(4000)
/
update  hpElement set strsqlwhere_1 = strsqlwhere
/
ALTER table  hpElement  drop column strsqlwhere
/
ALTER TABLE hpElement RENAME COLUMN strsqlwhere_1 TO strsqlwhere
/
