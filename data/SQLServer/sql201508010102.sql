Delete from MainMenuInfo where id=10213
GO
EXECUTE MMConfig_U_ByInfoInsert 10162,5
GO
EXECUTE MMInfo_Insert 10213,124864,'预算变更流程','/fna/budget/wfset/budgetChange/FnaChangeWfSetEdit.jsp','mainFrame',10193,3,5,0,'',0,'',0,'','',0,'','',6
GO


update MainMenuInfo 
set defaultIndex = 13 
where id = 10213 
GO

update mainmenuconfig 
set viewIndex = 13 
where infoId = 10213 
GO