delete from MainMenuInfo where labelid = 16674 and defaultParentId = 219
GO
update LeftMenuInfo set parentId = -674 where parentId = 674
GO
Delete from LeftMenuInfo where id = 674
GO
EXECUTE LMConfig_U_ByInfoInsert 2,5,80
GO
EXECUTE LMInfo_Insert 674,125798,'/images_face/ecologyFace_2/LeftMenuIcon/HRM_45.png','/hrm/schedule/hrmScheduleSet/tab.jsp?topage=myschedule',2,5,80,2
GO

Delete from MainMenuInfo where id=10225
GO
EXECUTE MMConfig_U_ByInfoInsert 47,39
GO
EXECUTE MMInfo_Insert 10225,16692,'�Ű����','','',47,3,39,0,'',0,'',0,'','',0,'','',2
GO

Delete from MainMenuInfo where id=10226
GO
EXECUTE MMConfig_U_ByInfoInsert 10225,10
GO
EXECUTE MMInfo_Insert 10226,125799,'����ʱ��','/hrm/schedule/hrmScheduleWorktime/tab.jsp?topage=list','mainFrame',10225,3,10,1,'HrmSchedulingWorkTime:set',1,'HrmSchedulingWorkTime:set',0,'','',0,'','',2
GO

Delete from MainMenuInfo where id=10227
GO
EXECUTE MMConfig_U_ByInfoInsert 10225,20
GO
EXECUTE MMInfo_Insert 10227,125800,'�������','/hrm/schedule/hrmScheduleShiftsSet/home.jsp','mainFrame',10225,3,20,1,'HrmSchedulingShifts:set',1,'HrmSchedulingShifts:set',0,'','',0,'','',2
GO

Delete from MainMenuInfo where id=10228
GO
EXECUTE MMConfig_U_ByInfoInsert 10225,30
GO
EXECUTE MMInfo_Insert 10228,32766,'�Ű���Ա��Χ','/hrm/schedule/hrmSchedulePersonnel/tab.jsp?topage=list','mainFrame',10225,3,30,1,'HrmSchedulingPersonnel:set',1,'HrmSchedulingPersonnel:set',0,'','',0,'','',2
GO

Delete from MainMenuInfo where id=10229
GO
EXECUTE MMConfig_U_ByInfoInsert 10225,40
GO
EXECUTE MMInfo_Insert 10229,16695,'�Ű�����','/hrm/schedule/hrmScheduleSet/home.jsp','mainFrame',10225,3,40,1,'HrmScheduling:set',1,'HrmScheduling:set',0,'','',0,'','',2
GO