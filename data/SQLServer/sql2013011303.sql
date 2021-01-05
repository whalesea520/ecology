alter table mode_customsearch add defaultsql varchar(4000)
go
alter table mode_customsearch add disQuickSearch int
go
alter table mode_customsearch alter column customdesc varchar(4000)
go