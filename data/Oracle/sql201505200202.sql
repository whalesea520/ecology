Delete from MainMenuInfo where id=10193
/
call MMConfig_U_ByInfoInsert (1348,2)
/
call MMInfo_Insert (10193,21954,'流程设置','','',1348,3,2,0,'',0,'',0,'','',0,'','',6)
/


Delete from MainMenuInfo where id=10195
/
call MMConfig_U_ByInfoInsert (1348,4)
/
call MMInfo_Insert (10195,83183,'还款流程','/fna/budget/wfset/FnaRepaymentWfSetEdit.jsp','mainFrame',1348,3,4,0,'',0,'',0,'','',0,'','',6)
/


Delete from MainMenuInfo where id=10194
/
call MMConfig_U_ByInfoInsert (1348,3)
/
call MMInfo_Insert (10194,83182,'借款流程','/fna/budget/wfset/FnaBorrowWfSetEdit.jsp','mainFrame',1348,3,3,0,'',0,'',0,'','',0,'','',6)
/






update MainMenuInfo 
set defaultParentId = 10193, 
	defaultLevel = 3, 
	parentId = 10193,
	menuName = '报销流程',
	labelId = 83184,
	defaultIndex = 9
where id = 1351 
/

update mainmenuconfig 
set viewIndex = 9 
where infoId = 1351 
/




update MainMenuInfo 
set defaultParentId = 10193, 
	defaultLevel = 3, 
	parentId = 10193,
	defaultIndex = 3
where id = 10194 
/

update mainmenuconfig 
set viewIndex = 3 
where infoId = 10194 
/




update MainMenuInfo 
set defaultParentId = 10193, 
	defaultLevel = 3, 
	parentId = 10193,
	defaultIndex = 6
where id = 10195 
/

update mainmenuconfig 
set viewIndex = 6 
where infoId = 10195 
/