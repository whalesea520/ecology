alter table MeetingSet add roomConflictChk int
go
alter table MeetingSet add roomConflict int
go

update MeetingSet set roomConflictChk =  1 ,roomConflict =  1
go