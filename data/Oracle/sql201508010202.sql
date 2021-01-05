Delete from MainMenuInfo where id=10214
/
call MMConfig_U_ByInfoInsert (10162,6)
/
call MMInfo_Insert (10214,124980,'费用分摊流程','/fna/budget/wfset/budgetShare/FnaShareWfSetEdit.jsp','mainFrame',10193,3,6,0,'',0,'',0,'','',0,'','',6)
/


update MainMenuInfo 
set defaultIndex = 17 
where id = 10214 
/

update mainmenuconfig 
set viewIndex = 17 
where infoId = 10214 
/