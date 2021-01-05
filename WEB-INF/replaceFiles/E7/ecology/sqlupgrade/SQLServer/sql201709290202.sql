Delete from MainMenuInfo where id=10729
GO
EXECUTE MMConfig_U_ByInfoInsert 0,248
GO
EXECUTE MMInfo_Insert 10729,131742,'系统安全','/security/monitor/Monitor.jsp','mainFrame',0,0,248,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=10730
GO
EXECUTE MMConfig_U_ByInfoInsert 10729,2
GO
EXECUTE MMInfo_Insert 10730,131740,'安全监控','/security/monitor/Monitor.jsp','mainFrame',10729,1,2,0,'',0,'',0,'','',0,'','',9
GO

 
Delete from MainMenuInfo where id=10734
GO
EXECUTE MMConfig_U_ByInfoInsert 10730,1
GO
EXECUTE MMInfo_Insert 10734,131740,'安全监控','/security/monitor/Monitor.jsp','mainFrame',10730,2,1,0,'',0,'',0,'','',0,'','',9
GO 

Delete from MainMenuInfo where id=10735
GO
EXECUTE MMConfig_U_ByInfoInsert 10730,2
GO
EXECUTE MMInfo_Insert 10735,30089,'敏感词设置','/security/sensitive/SensitiveTab.jsp?_fromURL=4','mainFrame',10730,2,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=10736
GO
EXECUTE MMConfig_U_ByInfoInsert 10730,3
GO
EXECUTE MMInfo_Insert 10736,131741,'敏感词列表','/security/sensitive/SensitiveTab.jsp','mainFrame',10730,2,3,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=10737
GO
EXECUTE MMConfig_U_ByInfoInsert 10730,4
GO
EXECUTE MMInfo_Insert 10737,131598,'敏感词拦截日志','/security/sensitive/SensitiveTab.jsp?_fromURL=3','mainFrame',10730,2,4,0,'',0,'',0,'','',0,'','',9
GO

