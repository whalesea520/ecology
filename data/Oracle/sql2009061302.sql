DELETE from mainmenuinfo where id=788
/
DELETE from mainmenuinfo where defaultparentid=788 and menuName='配置数据源'
/
DELETE from mainmenuconfig where infoid=788
/

CALL MMConfig_U_ByInfoInsert(11,41)
/
CALL MMInfo_Insert(788,19928,'外部接口设置','','',11,1,41,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert(788,1)
/
CALL MMInfo_Insert(789,23076,'外部数据触发流程设置','/workflow/automaticwf/automaticsetting.jsp','mainFrame',788,2,1,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert(788,2)
/
CALL MMInfo_Insert(834,23660,'配置数据源','/servicesetting/datasourcesetting.jsp','mainFrame',788,2,2,0,'',0,'',0,'','',0,'','',9)
/
