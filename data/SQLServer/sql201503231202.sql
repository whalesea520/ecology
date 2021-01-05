Delete from MainMenuInfo where id=10175
GO
EXECUTE MMConfig_U_ByInfoInsert 205,1
GO
EXECUTE MMInfo_Insert 10175,82617,'费用汇总表','/fna/report/costSummary/costSummary.jsp','mainFrame',205,2,1,0,'',0,'costSummary:qry',0,'','',0,'','',6
GO




update MainMenuInfo 
set defaultIndex = -10
where id = 10175 
GO

update mainmenuconfig 
set viewIndex = -10 
where infoId = 10175 
GO