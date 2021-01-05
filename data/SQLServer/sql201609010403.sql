alter table MeetingSet add canchange char(1)
GO
alter table Meeting_Service_Type add usecheck char(1)
GO
alter table meeting_service_item add hrmids varchar(1000)
GO
alter table MeetingSet add serviceconflictchk int
GO
alter table MeetingSet add serviceconflict int
GO
alter table meeting add ck_services varchar(1000)
GO
update meeting set ck_isck=ck_isck+'0' where datalength(ck_isck)=2
GO