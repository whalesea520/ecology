alter table modeinfo add isdelete int
go
update modeinfo set isdelete=0 where isdelete is null
go
update modeinfo set isdelete=1 where modetype in (select id from modeTreeField where isdelete=1)
go
