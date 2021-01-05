DELETE from mainmenuinfo where id=788
GO
DELETE from mainmenuinfo where defaultparentid=788 and menuName='配置数据源'
GO
DELETE from mainmenuconfig where infoid=788
GO

EXECUTE MMConfig_U_ByInfoInsert 11,41
GO
EXECUTE MMInfo_Insert 788,19928,'外部接口设置','','',11,1,41,0,'',0,'',0,'','',0,'','',3
GO

EXECUTE MMConfig_U_ByInfoInsert 788,2
GO
EXECUTE MMInfo_Insert 834,23660,'配置数据源','/servicesetting/datasourcesetting.jsp','mainFrame',788,2,2,0,'',0,'',0,'','',0,'','',9
GO

EXECUTE MMConfig_U_ByInfoInsert 788,5
GO
EXECUTE MMInfo_Insert 837,23663,'配置计划任务接口','/servicesetting/schedulesetting.jsp','mainFrame',788,2,5,0,'',0,'',0,'','',0,'','',9
GO
