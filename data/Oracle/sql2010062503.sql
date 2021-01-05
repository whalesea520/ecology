ALTER table menucustom ADD sharetype_1 varchar2(500)
/
update  menucustom set sharetype_1 = sharetype
/
ALTER table  menucustom  drop column sharetype
/
ALTER TABLE menucustom RENAME COLUMN sharetype_1 TO sharetype
/
