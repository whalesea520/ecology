Delete from MainMenuInfo where id=10173
GO
EXECUTE MMConfig_U_ByInfoInsert 205,1
GO
EXECUTE MMInfo_Insert 10173,82605,'费用查询统计表','/fna/report/fanRptCost/fanRptCost.jsp','mainFrame',205,2,1,0,'',0,'TheCostOfQueryStatistics:query',0,'','',0,'','',6
GO


update MainMenuInfo 
set defaultIndex = -15
where id = 10173 
GO

update mainmenuconfig 
set viewIndex = -15 
where infoId = 10173 
GO