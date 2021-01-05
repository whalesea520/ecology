alter table MeetingRoom_share add  (seclevelMax number,deptlevelMax number,sublevelMax number)
/
alter table MeetingType_share add  (seclevelMax number,deptlevelMax number,sublevelMax number)
/
update MeetingRoom_share set seclevelMax = 100 where seclevelMax is null and permissiontype=3
/
update MeetingRoom_share set deptlevelMax = 100 where deptlevelMax is null and permissiontype=1
/
update MeetingRoom_share set sublevelMax = 100 where sublevelMax is null and permissiontype=6
/
update MeetingType_share set seclevelMax = 100 where seclevelMax is null and permissiontype=3
/
update MeetingType_share set deptlevelMax = 100 where deptlevelMax is null and permissiontype=1
/
update MeetingType_share set sublevelMax = 100 where sublevelMax is null and permissiontype=6
/