Delete from MainMenuInfo where id=10729
/
call MMConfig_U_ByInfoInsert(0,248)
/
call MMInfo_Insert(10729,131742,'ϵͳ��ȫ','/security/monitor/Monitor.jsp','mainFrame',0,0,248,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10730
/
call MMConfig_U_ByInfoInsert(10729,2)
/
call MMInfo_Insert(10730,131740,'��ȫ���','/security/monitor/Monitor.jsp','mainFrame',10729,1,2,0,'',0,'',0,'','',0,'','',9)
/

 
Delete from MainMenuInfo where id=10734
/
call MMConfig_U_ByInfoInsert(10730,1)
/
call MMInfo_Insert(10734,131740,'��ȫ���','/security/monitor/Monitor.jsp','mainFrame',10730,2,1,0,'',0,'',0,'','',0,'','',9)
/ 

Delete from MainMenuInfo where id=10735
/
call MMConfig_U_ByInfoInsert(10730,2)
/
call MMInfo_Insert(10735,30089,'���д�����','/security/sensitive/SensitiveTab.jsp?_fromURL=4','mainFrame',10730,2,2,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10736
/
call MMConfig_U_ByInfoInsert(10730,3)
/
call MMInfo_Insert(10736,131741,'���д��б�','/security/sensitive/SensitiveTab.jsp','mainFrame',10730,2,3,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=10737
/
call MMConfig_U_ByInfoInsert(10730,4)
/
call MMInfo_Insert(10737,131598,'���д�������־','/security/sensitive/SensitiveTab.jsp?_fromURL=3','mainFrame',10730,2,4,0,'',0,'',0,'','',0,'','',9)
/
