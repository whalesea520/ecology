Delete from MainMenuInfo where id=1433
/
call MMConfig_U_ByInfoInsert (1364,0)
/
call MMInfo_Insert (1433,33142,'成本中心设置','/fna/costCenter/CostCenter.jsp','mainFrame',1364,2,0,0,'',0,'',0,'','',0,'','',6)
/

update MainMenuInfo 
set defaultIndex = 6
where id = 1433 
/

update mainmenuconfig 
set viewIndex = 6 
where infoId = 1433 
/