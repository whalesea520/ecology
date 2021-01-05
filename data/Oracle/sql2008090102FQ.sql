delete from mainmenuinfo where id=383 or id=472
/

delete from mainmenuconfig where infoid=383 or infoid=472
/

call MMConfig_U_ByInfoInsert (11,9)
/
call MMInfo_Insert (472,18581,'分权设置','/system/DetachMSetEdit.jsp','mainFrame',11,1,9,0,'',0,'',0,'','',0,'','',9)
/

CALL MMConfig_U_ByInfoInsert(11,9)
/
CALL MMInfo_Insert (383,17869,'管理员设置','/systeminfo/sysadmin/sysadminList.jsp','mainFrame',11,1,9,0,'',0,'',0,'','',0,'','',9)
/
