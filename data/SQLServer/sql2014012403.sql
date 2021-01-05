alter table MeetingRoom_share drop column id
go
alter table MeetingRoom_share add id int identity(1,1) not null
go
alter table Meetingtype_share drop column id
go
alter table Meetingtype_share add id int identity(1,1) not null
go