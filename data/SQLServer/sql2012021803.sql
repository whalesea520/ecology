alter table workflow_nodefieldattr add caltype int null
go
update workflow_nodefieldattr set caltype=1 where attrcontent like '%doFieldSQL%'
go
update workflow_nodefieldattr set caltype=2 where attrcontent like '%doFieldMath%'
go
alter table workflow_nodefieldattr add othertype int null
go
alter table workflow_nodehtmllayout add cssfile int null
go

create table workflow_crmcssfile(
	id int IDENTITY,
	cssname varchar(200),
	realfilename varchar(200),
	realpath varchar(2000)
)
go