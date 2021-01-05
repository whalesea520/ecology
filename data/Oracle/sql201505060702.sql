Delete from MainMenuInfo where id=10189
/
CALL MMConfig_U_ByInfoInsert (10188,10)
/
CALL MMInfo_Insert (10189,82799,'调休设置','/hrm/attendance/paidLeave/home.jsp?cmd=set','mainFrame',10188,3,10,0,'HrmPaidLeave:setting',0,'HrmPaidLeave:setting',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10190
/
CALL MMConfig_U_ByInfoInsert (10188,20)
/
CALL MMInfo_Insert (10190,82800,'调休时间查询','/hrm/attendance/paidLeave/home.jsp?cmd=timeToQuery','mainFrame',10188,3,20,0,'HrmPaidLeaveTime:search',0,'HrmPaidLeaveTime:search',0,'','',0,'','',2)
/
