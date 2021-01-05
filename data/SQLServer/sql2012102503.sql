create table ofMucRoomUsers
(
	id int  identity(1,1) primary key,
	loginid  varchar(60),
	roomname varchar(200),
	jointime  bigint
)
GO
