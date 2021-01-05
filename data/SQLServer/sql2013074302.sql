delete from MainMenuInfo where linkAddress in ('/messager/setting/BaseSetting.jsp','/system/PluginLicenseUser.jsp?plugintype=messager');
GO
delete from MainMenuInfo where linkAddress in ('/messager/eimUserRole.jsp')
GO
EXECUTE MMConfig_U_ByInfoInsert 877,1
GO
EXECUTE MMInfo_Insert 912,31728,'用户互通权限设置','/messager/eimUserRole.jsp','mainFrame',877,2,1,0,'',0,'',0,'','',0,'','',9
GO
