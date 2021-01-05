insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22877',1,0,2)
go

update cptcodeset set value = 5 where showtype = 2 and showname = '18811'
go
update cptcodeset set value = 1 where showtype = 1 and showname = '22877'
go

update cptcode set isuse = 1 
go

alter table cptcode add assetdataflow varchar(10)
go
alter table cptcapitalcodeseq add assetid int
go
update cptcapitalcodeseq set assetid=-1
go
update cptcode set assetdataflow = 1 
go










