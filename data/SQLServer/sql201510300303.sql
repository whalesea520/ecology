create table HistoryMsg(
	id int primary key identity(1,1),
	fromUserId varchar(100),
	targetId varchar(100),
	targetType varchar(100),
	GroupId varchar(100),
	classname varchar(100),
	msgContent text,
	extra text,
	type varchar(100),
	imageUri varchar(100),
	dateTime varchar(100)
)
GO