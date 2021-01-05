call MMConfig_U_ByInfoInsert(4,13)
/
call MMInfo_Insert (842,20773,'自定义查询','','mainFrame',4,1,13,0,'',0,'',0,'','',0,'','',3)
/
call MMConfig_U_ByInfoInsert (842,0)
/
call MMInfo_Insert (843,23799,'自定义查询种类','/workflow/workflow/CustomQueryType.jsp','mainFrame',842,2,0,0,'',0,'',0,'','',0,'','',3)
/
update mainmenuinfo set defaultlevel=2,defaultparentid=842,defaultindex=1,parentid=842 where id=632
/
