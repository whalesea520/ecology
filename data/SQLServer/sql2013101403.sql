
Delete from MainMenuInfo where id=1267
GO
EXECUTE MMConfig_U_ByInfoInsert 377,2
GO
EXECUTE MMInfo_Insert 1267,31958,'∏ ÃÿÕº…Ë÷√','/proj/Maint/PrjGanttSet.jsp','mainFrame',377,2,2,0,'',0,'',0,'','',0,'','',5
GO


create table pm_ganttset
(
id int IDENTITY(1,1) primary key not null,
showplan_ char(1),
warning_day int
)
GO
