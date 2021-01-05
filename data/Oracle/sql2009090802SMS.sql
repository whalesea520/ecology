DELETE from mainmenuinfo where id=788
/

DELETE from mainmenuconfig where infoid=788
/

CALL MMConfig_U_ByInfoInsert(11,41)
/
CALL MMInfo_Insert(788,19928,'外部接口设置','','',11,1,41,0,'',0,'',0,'','',0,'','',3)
/


CALL MMConfig_U_ByInfoInsert(788,4)
/
CALL MMInfo_Insert(836,23664,'配置短信接口','/servicesetting/smssetting.jsp','mainFrame',788,2,4,0,'',0,'',0,'','',0,'','',9)
/
