Delete from MainMenuInfo where id=10174
/
call MMConfig_U_ByInfoInsert (205,1)
/
call MMInfo_Insert (10174,82612,'预算执行情况表','/fna/report/fnaRptImplementation/fnaRptImplementation.jsp','mainFrame',205,2,1,0,'',0,'fnaRptImplementation:qry',0,'','',0,'','',6)
/



update MainMenuInfo 
set defaultIndex = -18
where id = 10174 
/

update mainmenuconfig 
set viewIndex = -18 
where infoId = 10174 
/



update MainMenuInfo 
set defaultIndex = -5
where id = 10173 
/

update mainmenuconfig 
set viewIndex = -5 
where infoId = 10173 
/