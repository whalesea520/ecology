delete from MainMenuInfo where linkAddress in ('/messager/setting/BaseSetting.jsp','/system/PluginLicenseUser.jsp?plugintype=messager')
/
delete from MainMenuInfo where linkAddress in ('/messager/eimUserRole.jsp')
/
call MMConfig_U_ByInfoInsert ( 877,1)
/
call MMInfo_Insert (912,31728,'用户互通权限设置','/messager/eimUserRole.jsp','mainFrame',877,2,1,0,'',0,'',0,'','',0,'','',9) 
/
