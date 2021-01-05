Delete from MainMenuInfo where id=1020
GO
EXECUTE MMConfig_U_ByInfoInsert 4,15
GO
EXECUTE MMInfo_Insert 1020,16758,'流程监控','','mainFrame',4,1,15,0,'',0,'',0,'','',0,'','',3
GO

Delete from MainMenuInfo where id=1022
GO
EXECUTE MMConfig_U_ByInfoInsert 1020,1
GO
EXECUTE MMInfo_Insert 1022,2239,'监控类型','/workflow/monitor/CustomMonitorType.jsp','mainFrame',1020,2,1,0,'',0,'',0,'','',0,'','',3
GO

Delete from MainMenuInfo where id=1030
GO
EXECUTE MMConfig_U_ByInfoInsert 4,11
GO
EXECUTE MMInfo_Insert 1030,26504,'报表设置','','mainFrame',4,1,11,0,'',0,'',0,'','',0,'','',3
GO
