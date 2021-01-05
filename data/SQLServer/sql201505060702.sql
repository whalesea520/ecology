Delete from MainMenuInfo where id=10189
GO
EXECUTE MMConfig_U_ByInfoInsert 10188,10
GO
EXECUTE MMInfo_Insert 10189,82799,'调休设置','/hrm/attendance/paidLeave/home.jsp?cmd=set','mainFrame',10188,3,10,0,'HrmPaidLeave:setting',0,'HrmPaidLeave:setting',0,'','',0,'','',2
GO
Delete from MainMenuInfo where id=10190
GO
EXECUTE MMConfig_U_ByInfoInsert 10188,20
GO
EXECUTE MMInfo_Insert 10190,82800,'调休时间查询','/hrm/attendance/paidLeave/home.jsp?cmd=timeToQuery','mainFrame',10188,3,20,0,'HrmPaidLeaveTime:search',0,'HrmPaidLeaveTime:search',0,'','',0,'','',2
GO