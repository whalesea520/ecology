alter table workflow_base add wfdocownertype int null
go
alter table workflow_base add wfdocownerfieldid int null
go
update workflow_base set wfdocownertype=1 where wfdocowner is not null and wfdocowner>0
go
