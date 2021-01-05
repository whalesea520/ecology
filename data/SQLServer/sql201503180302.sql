Delete from MainMenuInfo where id=10174
GO
EXECUTE MMConfig_U_ByInfoInsert 205,1
GO
EXECUTE MMInfo_Insert 10174,82612,'预算执行情况表','/fna/report/fnaRptImplementation/fnaRptImplementation.jsp','mainFrame',205,2,1,0,'',0,'fnaRptImplementation:qry',0,'','',0,'','',6
GO



update MainMenuInfo 
set defaultIndex = -18
where id = 10174 
GO

update mainmenuconfig 
set viewIndex = -18 
where infoId = 10174 
GO



update MainMenuInfo 
set defaultIndex = -5
where id = 10173 
GO

update mainmenuconfig 
set viewIndex = -5 
where infoId = 10173 
GO