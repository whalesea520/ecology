Delete from MainMenuInfo where id=10172
GO
EXECUTE MMConfig_U_ByInfoInsert 205,1
GO
EXECUTE MMInfo_Insert 10172,82502,'Ô¤Ëã×Ü¶î±í','/fna/report/fanRptTotalBudget/fanRptTotalBudget.jsp','mainFrame',205,2,1,0,'',0,'TotalBudgetTable:qry',0,'','',0,'','',6
GO


update MainMenuInfo 
set defaultIndex = -20
where id = 10172 
GO

update mainmenuconfig 
set viewIndex = -20 
where infoId = 10172 
GO