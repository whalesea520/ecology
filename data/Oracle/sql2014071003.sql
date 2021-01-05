alter table MeetingSet add roomConflictChk INTEGER
/
alter table MeetingSet add roomConflict INTEGER
/

update MeetingSet set roomConflictChk =  1 ,roomConflict =  1
/
