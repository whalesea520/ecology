alter table OfNoticeRote add groupauth numeric(1,0) 
go
update OfNoticeRote set groupauth=0
go