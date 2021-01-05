update LeftMenuConfig SET visible=1 WHERE infoId = 42
/
update LeftMenuConfig SET viewIndex=1 WHERE infoId = 49
/
update LeftMenuConfig SET viewIndex=2 WHERE infoId = 42
/
update LeftMenuConfig SET viewIndex=3 WHERE infoId = 43
/
update LeftMenuConfig SET viewIndex=4 WHERE infoId = 44
/
update LeftMenuConfig SET viewIndex=5 WHERE infoId = 45
/
update LeftMenuConfig SET viewIndex=6 WHERE infoId = 47
/
update LeftMenuConfig SET viewIndex=7 WHERE infoId = 48
/
update LeftMenuConfig SET viewIndex=8 WHERE infoId = 162
/
update LeftMenuConfig SET viewIndex=9 WHERE infoId = 219
/
update LeftMenuConfig SET viewIndex=10 WHERE infoId = 241
/
update LeftMenuConfig SET visible=0 WHERE infoId = -53
/
UPDATE MainMenuInfo SET linkAddress ='/hrm/jobactivities/index.jsp' WHERE id=61
/
UPDATE MainMenuInfo SET labelId = 33596 WHERE id=55
/
UPDATE mainmenuconfig SET visible = 1 WHERE infoId=58
/
Delete from MainMenuInfo where id=1339
/
CALL MMConfig_U_ByInfoInsert (47,3)
/
CALL MMInfo_Insert (1339,33545,'ÔÚÏßÇ©µ½¿¼ÇÚ','/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet','mainFrame',47,2,3,0,'',1,'HrmkqSystemSetEdit:Edit',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=94
/
CALL MMConfig_U_ByInfoInsert (48,1)
/
CALL MMInfo_Insert (94,6131,'','/hrm/HrmTab.jsp?_fromURL=useDemand','mainFrame',48,2,1,0,'',1,'HrmUseDemandAdd:Add',0,'','',0,'','',2)
/
UPDATE MainMenuInfo SET linkAddress ='/hrm/HrmTab.jsp?_fromURL=DocMould' WHERE id=99
/
UPDATE MainMenuInfo SET labelId = 33398 WHERE id=104
/
update mainmenuconfig SET visible=0 WHERE infoId = 320
/
UPDATE MainMenuInfo SET linkAddress ='/hrm/schedule/HrmDefaultSechedule_frm.jsp' WHERE id=84
/
update MainMenuInfo SET labelid=6130 WHERE id = 105
/
UPDATE LeftMenuInfo SET linkAddress ='/hrm/search/HrmResourceSearch_frm.jsp' WHERE id=49
/