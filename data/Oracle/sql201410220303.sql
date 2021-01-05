alter table modeinfo add isdelete int
/
update modeinfo set isdelete=0 where isdelete is null
/
update modeinfo set isdelete=1 where modetype in (select id from modeTreeField where isdelete=1)
/
