Delete from MainMenuInfo where id=10186
/
call MMConfig_U_ByInfoInsert (219,10)
/
call MMInfo_Insert (10186,82801,'月考勤日历报表','/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=HrmMonthAttendanceReport','mainFrame',219,3,10,0,'HrmMonthAttendanceReport:report',0,'HrmMonthAttendanceReport:report',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10187
/
call MMConfig_U_ByInfoInsert (47,19)
/
call MMInfo_Insert (10187,82797,'考勤流程设置','/hrm/attendance/hrmAttProcSet/home.jsp','mainFrame',47,3,19,0,'HrmAttendanceProcess:setting',0,'HrmAttendanceProcess:setting',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10188
/
call MMConfig_U_ByInfoInsert (47,25)
/
call MMInfo_Insert (10188,82798,'调休管理','','',47,3,25,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10189
/
call MMConfig_U_ByInfoInsert (10188,10)
/
call MMInfo_Insert (10189,82799,'调休设置','/hrm/attendance/paidLeaveManagement/paidLeaveSettings/home.jsp','mainFrame',10188,3,10,0,'HrmPaidLeave:setting',0,'HrmPaidLeave:setting',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=10190
/
call MMConfig_U_ByInfoInsert (10188,20)
/
call MMInfo_Insert (10190,82800,'调休时间查询','/hrm/attendance/paidLeaveManagement/timeToQuery/home.jsp','mainFrame',10188,3,20,0,'HrmPaidLeaveTime:search',0,'HrmPaidLeaveTime:search',0,'','',0,'','',2)
/