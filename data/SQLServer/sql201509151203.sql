update prjDefineField set fielddbtype='varchar(500)' where fieldname='name'
go
alter table prj_projectinfo alter column name varchar(500)
go
