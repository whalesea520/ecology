DELETE from mainmenuinfo where id=788
/
DELETE from mainmenuinfo where defaultparentid=788 and menuName='��������Դ'
/
DELETE from mainmenuconfig where infoid=788
/

CALL MMConfig_U_ByInfoInsert(11,41)
/
CALL MMInfo_Insert(788,19928,'�ⲿ�ӿ�����','','',11,1,41,0,'',0,'',0,'','',0,'','',3)
/

CALL MMConfig_U_ByInfoInsert(788,2)
/
CALL MMInfo_Insert(834,23660,'��������Դ','/servicesetting/datasourcesetting.jsp','mainFrame',788,2,2,0,'',0,'',0,'','',0,'','',9)
/

CALL MMConfig_U_ByInfoInsert(788,5)
/
CALL MMInfo_Insert(837,23663,'���üƻ�����ӿ�','/servicesetting/schedulesetting.jsp','mainFrame',788,2,5,0,'',0,'',0,'','',0,'','',9)
/