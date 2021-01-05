alter table RTXSetting add userattr varchar(400)
go
alter table RTXSetting add username varchar(400)
go
alter table RTXSetting add rtxLoginToOA char(1)
go
 create table imsynlog
 (
	id int IDENTITY(1,1),
	syntype char(1),
	syndata varchar(500),
	opertype char(1),
	operresult char(1),
	reason varchar(800),
	operdate varchar(10),
	opertime varchar(8)
 )
 go