delete from MainMenuInfo where labelid = 16674 and defaultParentId = 219
/
update LeftMenuInfo set parentId = -674 where parentId = 674
/
Delete from LeftMenuInfo where id = 674
/
call LMConfig_U_ByInfoInsert (2,5,80)
/
call LMInfo_Insert (674,125798,'/images_face/ecologyFace_2/LeftMenuIcon/HRM_45.png','/hrm/schedule/hrmScheduleSet/tab.jsp?topage=myschedule',2,5,80,2)
/

Delete from MainMenuInfo where id=10225
/
call MMConfig_U_ByInfoInsert (47,39)
/
call MMInfo_Insert (10225,16692,'排班管理','','',47,3,39,0,'',0,'',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=10226
/
call MMConfig_U_ByInfoInsert (10225,10)
/
call MMInfo_Insert (10226,125799,'工作时段','/hrm/schedule/hrmScheduleWorktime/tab.jsp?topage=list','mainFrame',10225,3,10,1,'HrmSchedulingWorkTime:set',1,'HrmSchedulingWorkTime:set',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=10227
/
call MMConfig_U_ByInfoInsert (10225,20)
/
call MMInfo_Insert (10227,125800,'班次设置','/hrm/schedule/hrmScheduleShiftsSet/home.jsp','mainFrame',10225,3,20,1,'HrmSchedulingShifts:set',1,'HrmSchedulingShifts:set',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=10228
/
call MMConfig_U_ByInfoInsert (10225,30)
/
call MMInfo_Insert (10228,32766,'排班人员范围','/hrm/schedule/hrmSchedulePersonnel/tab.jsp?topage=list','mainFrame',10225,3,30,1,'HrmSchedulingPersonnel:set',1,'HrmSchedulingPersonnel:set',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=10229
/
call MMConfig_U_ByInfoInsert (10225,40)
/
call MMInfo_Insert (10229,16695,'排班设置','/hrm/schedule/hrmScheduleSet/home.jsp','mainFrame',10225,3,40,1,'HrmScheduling:set',1,'HrmScheduling:set',0,'','',0,'','',2)
/