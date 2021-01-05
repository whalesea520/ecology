Delete from MainMenuInfo where id=10172
/
call MMConfig_U_ByInfoInsert (205,1)
/
call MMInfo_Insert (10172,82502,'Ô¤Ëã×Ü¶î±í','/fna/report/fanRptTotalBudget/fanRptTotalBudget.jsp','mainFrame',205,2,1,0,'',0,'TotalBudgetTable:qry',0,'','',0,'','',6)
/


update MainMenuInfo 
set defaultIndex = -20
where id = 10172 
/

update mainmenuconfig 
set viewIndex = -20 
where infoId = 10172 
/
