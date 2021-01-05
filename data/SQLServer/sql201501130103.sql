create table mode_layout_querySql
(
id int identity(1,1) not null,
modeid int,
formid int,
layoutid int,
detailtype int,
queryType int default(0) not null,
sqlConetent varchar(3000),
javaFileName varchar(200)
)
go
create table mode_layout_sortfield
(
 id int identity(1,1) not null,
 modeid int,
 formid int,
 layoutid int,
 fieldid int,
 issort int default(0)
)
go