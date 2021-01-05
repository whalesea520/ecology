Delete from MainMenuInfo where id=1381
GO
EXECUTE MMConfig_U_ByInfoInsert 11,86
GO
EXECUTE MMInfo_Insert 1381,24751,'邮件设置','','',11,1,86,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1382
GO
EXECUTE MMConfig_U_ByInfoInsert 1381,0
GO
EXECUTE MMInfo_Insert 1382,15037,'邮件系统设置','/email/maint/MailSystemFrame.jsp','',1381,2,0,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1383
GO
EXECUTE MMConfig_U_ByInfoInsert 1381,1
GO
EXECUTE MMInfo_Insert 1383,33447,'邮件模板设置','/email/maint/MailTemplateFrame.jsp','',1381,2,1,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1384
GO
EXECUTE MMConfig_U_ByInfoInsert 1381,2
GO
EXECUTE MMInfo_Insert 1384,33448,'邮件监控设置','/email/maint/MailMonitorFrame.jsp','',1381,2,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1385
GO
EXECUTE MMConfig_U_ByInfoInsert 1381,3
GO
EXECUTE MMInfo_Insert 1385,33449,'企业邮箱管理','/email/maint/MailEnterpriseFrame.jsp','',1381,2,3,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1386
GO
EXECUTE MMConfig_U_ByInfoInsert 1381,4
GO
EXECUTE MMInfo_Insert 1386,33450,'邮箱空间管理','/email/new/MailSpaceFrame.jsp','',1381,2,4,0,'',0,'',0,'','',0,'','',9
GO