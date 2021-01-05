alter table modecodedetail add shownamestr varchar(100)
GO
alter table modecodedetail add fieldnamestr varchar(100)
GO
create table mode_newserialnum
(
   ID INT primary key identity(1,1),
   codemainid int,
   condition varchar(500),
   num int
)
GO