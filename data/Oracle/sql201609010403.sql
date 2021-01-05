alter table MeetingSet add canchange char(1)
/
alter table MeetingSet add serviceconflictchk int
/
alter table MeetingSet add serviceconflict int
/
alter table Meeting_Service_Type add usecheck char(1)
/
alter table meeting_service_item add hrmids varchar2(1000)
/
alter table meeting add ck_services varchar2(1000)
/
update meeting set ck_isck=ck_isck||'0' where length(ck_isck)=2
/