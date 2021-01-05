Delete from MainMenuInfo where id=10223
/
call MMConfig_U_ByInfoInsert (10218,2)
/
call MMInfo_Insert (10223,125597,'费用标准流程','/fna/costStandard/wfset/costStandardWfSetEdit.jsp','mainFrame',10218,3,2,0,'',0,'',0,'','',0,'','',6)
/

Delete from MainMenuInfo where id=10219
/
call MMConfig_U_ByInfoInsert (10218,0)
/
call MMInfo_Insert (10219,125499,'费用标准维度','/fna/costStandard/costStandard.jsp','mainFrame',10218,3,0,0,'',0,'',0,'','',0,'','',6)
/

Delete from MainMenuInfo where id=10222
/
call MMConfig_U_ByInfoInsert (10218,1)
/
call MMInfo_Insert (10222,125521,'费用标准设置','/fna/costStandard/costStandardDefi.jsp','mainFrame',10218,3,1,0,'',0,'',0,'','',0,'','',6)
/


Delete from MainMenuInfo where id=10218
/
call MMConfig_U_ByInfoInsert (7,4)
/
call MMInfo_Insert (10218,125500,'费用标准','','',7,2,4,0,'',0,'',0,'','',0,'','',6)
/