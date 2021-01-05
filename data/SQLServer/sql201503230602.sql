Delete from MainMenuInfo where id=10176
GO
EXECUTE MMConfig_U_ByInfoInsert 205,1
GO
EXECUTE MMInfo_Insert 10176,82629,'费用预算细化表','/fna/report/budgetDetailed/budgetDetailed.jsp','mainFrame',205,2,1,0,'',0,'fnaRptBudgetDetailed:qry',0,'','',0,'','',6
GO


update MainMenuInfo 
set defaultIndex = -7
where id = 10176 
GO

update mainmenuconfig 
set viewIndex = -7 
where infoId = 10176 
GO