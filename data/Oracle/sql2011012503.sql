ALTER table  menucustom  ADD MENUHREF_1 varchar2(4000)
/
update  menucustom set MENUHREF_1 = MENUHREF
/
ALTER table  menucustom  drop column MENUHREF
/
ALTER TABLE menucustom RENAME COLUMN MENUHREF_1 TO MENUHREF
/
