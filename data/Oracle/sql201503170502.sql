Delete from MainMenuInfo where id=10173
/
call MMConfig_U_ByInfoInsert (205,1)
/
call MMInfo_Insert (10173,82605,'���ò�ѯͳ�Ʊ�','/fna/report/fanRptCost/fanRptCost.jsp','mainFrame',205,2,1,0,'',0,'TheCostOfQueryStatistics:query',0,'','',0,'','',6)
/


update MainMenuInfo 
set defaultIndex = -15
where id = 10173 
/

update mainmenuconfig 
set viewIndex = -15 
where infoId = 10173 
/