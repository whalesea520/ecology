Delete from MainMenuInfo where id=10214
GO
EXECUTE MMConfig_U_ByInfoInsert 10162,6
GO
EXECUTE MMInfo_Insert 10214,124980,'���÷�̯����','/fna/budget/wfset/budgetShare/FnaShareWfSetEdit.jsp','mainFrame',10193,3,6,0,'',0,'',0,'','',0,'','',6
GO


update MainMenuInfo 
set defaultIndex = 17 
where id = 10214 
GO

update mainmenuconfig 
set viewIndex = 17 
where infoId = 10214 
GO