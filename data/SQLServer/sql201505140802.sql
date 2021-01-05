Delete from MainMenuInfo where id=10191
GO
EXECUTE MMConfig_U_ByInfoInsert 8,9
GO
EXECUTE MMInfo_Insert 10191,82855,'资产数量预警设置','/cpt/conf/cptalertnumconf.jsp','mainFrame',8,2,9,0,'',0,'',0,'','',0,'','',7
GO

Delete from MainMenuInfo where id=10192
GO
EXECUTE MMConfig_U_ByInfoInsert 8,10
GO
EXECUTE MMInfo_Insert 10192,82856,'资产变更维护','/cpt/maintenance/cptmodify.jsp','mainFrame',8,2,10,0,'',0,'',0,'','',0,'','',7
GO