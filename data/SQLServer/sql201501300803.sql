alter table MeetingSet add recArrive int
go
alter table MeetingSet add recBook int
go
alter table MeetingSet add recReturn int
go
alter table MeetingSet add recRemark int
go
update MeetingSet set recArrive=1,recBook=1,recReturn=1,recRemark=0
go

alter table Meeting_Member2 add recRemark varchar(255)
go