alter table MeetingRoom_share add  seclevelMax int,deptlevelMax int,sublevelMax int
GO
alter table MeetingType_share add  seclevelMax int,deptlevelMax int,sublevelMax int
GO
update MeetingRoom_share set seclevelMax = 100 where seclevelMax is null and permissiontype=3
GO
update MeetingRoom_share set deptlevelMax = 100 where deptlevelMax is null and permissiontype=1
GO
update MeetingRoom_share set sublevelMax = 100 where sublevelMax is null and permissiontype=6
GO
update MeetingType_share set seclevelMax = 100 where seclevelMax is null and permissiontype=3
GO
update MeetingType_share set deptlevelMax = 100 where deptlevelMax is null and permissiontype=1
GO
update MeetingType_share set sublevelMax = 100 where sublevelMax is null and permissiontype=6
GO