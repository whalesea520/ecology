Delete from MainMenuInfo where id=1433
GO
EXECUTE MMConfig_U_ByInfoInsert 1364,0
GO
EXECUTE MMInfo_Insert 1433,33142,'成本中心设置','/fna/costCenter/CostCenter.jsp','mainFrame',1364,2,0,0,'',0,'',0,'','',0,'','',6
GO
update MainMenuInfo 
set defaultIndex = 6
where id = 1433 
GO

update mainmenuconfig 
set viewIndex = 6 
where infoId = 1433 
GO