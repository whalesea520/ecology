alter table MeetingSet add recArrive int
/
alter table MeetingSet add recBook int
/
alter table MeetingSet add recReturn int
/
alter table MeetingSet add recRemark int
/
update MeetingSet set recArrive=1,recBook=1,recReturn=1,recRemark=0
/

alter table Meeting_Member2 add recRemark varchar(255)
/