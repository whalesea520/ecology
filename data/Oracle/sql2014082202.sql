update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=useDemand' where id = 94 and labelId = 6131
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=careerPlan' where id = 95 and labelId = 6132
/
delete from MainMenuInfo  where id = 98
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=inviteInfo' , labelId = 366 where id = 97
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=applyInfo', defaultIndex = 5 where id = 96 and labelId = 16251
/
UPDATE mainmenuconfig SET viewIndex = 5  WHERE infoId = 96 
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=SystemRightGroup' where id = 352 and labelId = 16526
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmRightTransfer' where id = 354 and labelId = 16528
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmCheckItem' where id = 113 and labelId = 6117
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmCheckInfo&cmd=15652' where id = 114 and labelId = 6124
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmCountry' where id = 348 and labelId = 16522
/
update MainMenuInfo set linkAddress = '/hrm/province/HrmProvince_frm.jsp' where id = 349 and labelId = 16523
/
update MainMenuInfo set linkAddress = '/hrm/city/HrmCity_frm.jsp' where id = 350 and labelId = 16524
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=fnaCurrencies' where id = 351 and labelId = 16525
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=lgcAssetUnit' where id = 1328 and labelId = 16511
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmArrangeShiftReport' where id = 311 and labelId = 16674
/
update MainMenuInfo set defaultParentId = 219,parentId = 219  where id = 290
/
delete  from MainMenuInfo where id in (307,309,310)
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmRpAbsense' where id = 290 and labelId = 16547
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=schedulediff&method=HrmScheduleDiffReport' where id = 308 and labelId = 16559
/
update MainMenuInfo set defaultParentId = -214,parentId = -214 where id not in (273,274,282) and parentId = 214
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmConstRpSubSearch&scopeid=1' 
where id = 273 and labelId = 15687
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmConstRpSubSearch&scopeid=3' 
where id = 274 and labelId = 15688
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmConst&method=HrmCustomFieldReport' 
where id = 282 and labelId = 17088
/
update MainMenuInfo set defaultParentId = -217,parentId = -217 where id = 287 and parentId = 217
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmAgeRp' 
where id = 288 and labelId = 16545
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=HrmJobLevelRp' 
where id = 289 and labelId = 16546
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmSexRp' 
where id = 291 and labelId = 16548
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmWorkageRp' 
where id = 292 and labelId = 16549
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmEducationLevelRp' 
where id = 293 and labelId = 16550
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmDepartmentRp' 
where id = 294 and labelId = 16551
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=HrmJobTitleRp' 
where id = 295 and labelId = 16552
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=HrmJobActivityRp' 
where id = 296 and labelId = 16553
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=HrmJobGroupRp' 
where id = 297 and labelId = 805
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=HrmJobCallRp' 
where id = 298 and labelId = 16554
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmStatusRp' 
where id = 299 and labelId = 16555
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmUsekindRp' 
where id = 300 and labelId = 804
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmMarriedRp' 
where id = 301 and labelId = 469
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmResource&method=hrmSecLevelRp' 
where id = 302 and labelId = 683
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmContract' 
where id = 221 and labelId = 16572
/
update MainMenuInfo set labelid = 32758 where id = 706 and labelid = 21599
/
update MainMenuInfo set labelid = 21600 where id = 707 and labelid = 21590
/
update MainMenuInfo set labelid = 33612,menuName = '带薪病假设置' where id = 889 and labelid = 24037
/
update MainMenuInfo set defaultIndex = 0 where id = 84 and labelid = 16687
/
UPDATE mainmenuconfig SET viewIndex = 0 WHERE infoId = 84
/
update MainMenuInfo set defaultIndex = 5 where id = 85 and labelid = 16750
/
UPDATE mainmenuconfig SET viewIndex = 5 WHERE infoId = 85
/
update MainMenuInfo set defaultIndex = 10 where id = 86 and labelid = 16255
/
UPDATE mainmenuconfig SET viewIndex = 10 WHERE infoId = 86
/
update MainMenuInfo set defaultIndex = 15 where id = 87 and labelid = 16256
/
UPDATE mainmenuconfig SET viewIndex = 15 WHERE infoId = 87
/
update MainMenuInfo set defaultIndex = 20,defaultParentId = 47,parentId = 47 where id = 708 and labelid = 21609
/
UPDATE mainmenuconfig SET viewIndex = 20 WHERE infoId = 708
/
update MainMenuInfo set defaultIndex = 25 where id = 704 and labelid = 21600
/
UPDATE mainmenuconfig SET viewIndex = 25 WHERE infoId = 704
/
update MainMenuInfo set defaultIndex = 30 where id = 873 and labelid = 24037
/
UPDATE mainmenuconfig SET viewIndex = 30 WHERE infoId = 873
/
update MainMenuInfo set defaultIndex = 35 where id = 1339 and labelid = 33545
/
UPDATE mainmenuconfig SET viewIndex = 35 WHERE infoId = 1339
/
update MainMenuInfo set defaultIndex = 40 where id = 1344 and labelid = 33067
/
UPDATE mainmenuconfig SET viewIndex = 40 WHERE infoId = 1344
/
update MainMenuInfo set defaultIndex = 45 where id = 1395 and labelid = 33548
/
UPDATE mainmenuconfig SET viewIndex = 45 WHERE infoId = 1395
/
update MainMenuInfo set defaultParentId = -47,parentId = -47 where id not in (84,85,86,87,708,704,873,1339,1344,1395) and parentId = 47
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmSalary&method=HrmRpMonthSalarySum' 
where id = 223 and labelId = 17537
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=hrmReport&cmd=hrmSalary&method=HrmRpResourceSalarySum' 
where id = 224 and labelId = 17538
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=systemLog&cmd=SysMaintenanceLog' 
where id = 211 and labelId = 18168
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=systemLog&cmd=HrmOnlineRp' 
where id = 1250 and labelId = 31277
/
update MainMenuInfo set linkAddress = '/hrm/HrmTab.jsp?_fromURL=systemLog&cmd=HrmRefuseRp' 
where id = 1254 and labelId = 31310
/
update MainMenuInfo set defaultParentId = -200,parentId = -200 where id in (212,213,215,216,218) and parentId = 200
/
Call MMConfig_U_ByInfoInsert (1308,3)
/
Call MMInfo_Insert (1308,32496,NULL,'/hrm/HrmTab.jsp?_fromURL=HrmSecuritySetting','mainFrame',3,2,2,0,'',0,'',0,'','',0,'','',2)
/
Call MMConfig_U_ByInfoInsert (1309,3)
/
Call MMInfo_Insert (1309,32510,NULL,'/hrm/resource/HrmResourceSys_frm.jsp','mainFrame',3,2,2,0,'',0,'',0,'','',0,'','',2)
/
Call MMConfig_U_ByInfoInsert (1279,3)
/
Call MMInfo_Insert (1279,22528,NULL,NULL,'mainFrame',54,2,2,0,'',0,'',0,'','',0,'','',2)
/
Call MMConfig_U_ByInfoInsert (1305,3)
/
Call MMInfo_Insert (1305,17037,NULL,'/hrm/resource/HrmCustomFieldManagerIndex.jsp','mainFrame',1279,2,2,0,'',0,'',0,'','',0,'','',2)
/
Call MMConfig_U_ByInfoInsert (1329,3)
/
Call MMInfo_Insert (1329,32486,NULL,NULL,'mainFrame',46,2,2,0,'',0,'',0,'','',0,'','',2)
/
Call MMConfig_U_ByInfoInsert (1304,3)
/
Call MMInfo_Insert (1304,21946,NULL,'/hrm/setting/HrmAlarmSettingIndex.jsp','mainFrame',46,2,2,0,'',0,'',0,'','',0,'','',2)
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/search/HrmResourceSearch_frm.jsp', defaultIndex=1 WHERE id =49
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/resource/OnlineUser_frm.jsp',defaultIndex =11 WHERE id =219
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/hrmTab.jsp?_fromURL=HrmResourcePassword', defaultIndex =10 WHERE id =241
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceRewardsRecord', defaultIndex =9 WHERE id = 48
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceAbsense', defaultIndex =9 WHERE id = 162
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceFinanceView', defaultIndex =6 WHERE id = 47
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceTrainRecord', defaultIndex =4, labelId=32569  WHERE id = 45
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceView', defaultIndex =3 WHERE id = 44
/
UPDATE  leftmenuinfo SET linkAddress = '/hrm/resource/HrmResource.jsp', defaultIndex =2 WHERE id = 43
/
UPDATE  LeftMenuConfig SET visible =0 WHERE infoId = 42 
/
UPDATE  LeftMenuConfig SET visible =0 WHERE infoId = 161
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=companyEdit',parentId=3,defaultParentId=3 WHERE id =44
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=location',parentId=45,defaultParentId=45 WHERE id =59
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=jobactivitiesSet',parentId=45,defaultParentId=45 WHERE id =61
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/jobtitles/HrmJobTitles_frm.jsp',parentId=45,defaultParentId=45 WHERE id =62
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 55
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 58
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 60
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 736
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 140
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 69
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 694
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 70
/
UPDATE  mainmenuconfig SET visible =1 WHERE infoId = 80
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 115
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 116
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 387
/
UPDATE  mainmenuconfig SET visible =0 WHERE infoId = 375
/
UPDATE MainMenuInfo SET linkAddress = NULL, labelId=32470 WHERE id= 54
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmValidate',parentId=1279,defaultParentId=1279 WHERE id =68
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=company',parentId=54,defaultParentId=54, labelId=32471 WHERE id =67
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=department',parentId=54,defaultParentId=54, labelId=32474 WHERE id =1258
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/employee/EmployeeTab.jsp',parentId=46,defaultParentId=46, labelId=32775 WHERE id =80
/
UPDATE  MainMenuInfo SET linkAddress = NULL,parentId=3,defaultParentId=3, labelId=15882 WHERE id =46
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceHire', parentId=1329, defaultParentId=1329 WHERE id=72
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceExtend', parentId=1329, defaultParentId=1329 WHERE id=73
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceRedeploy', parentId=1329, defaultParentId=1329 WHERE id=74
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceDismiss', parentId=1329, defaultParentId=1329,labelId=16469 WHERE id=75
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceRetire', parentId=1329, defaultParentId=1329 WHERE id=76
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceRehire', parentId=1329, defaultParentId=1329 WHERE id=77
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceFire', parentId=1329, defaultParentId=1329 WHERE id=78
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmResourceTry', parentId=1329, defaultParentId=1329 WHERE id=79
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=jobcall' WHERE id=63
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=speciality' WHERE id=64
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=educationlevel' WHERE id=65
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=usekind' WHERE id=66
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=EmployeeInfoMaintenance' WHERE id=80
/

UPDATE MainMenuInfo SET parentId= 1333,defaultParentId=46 WHERE Id >=72 AND Id < 80
/
Delete from MainMenuInfo where id=1333
/
Call MMConfig_U_ByInfoInsert (46,1)
/
Call MMInfo_Insert (1333,32486,'人事状态变更','','',46,2,1,0,'',0,'',0,'','',0,'','',2)
/

Call MMConfig_U_ByInfoInsert (47,1)
/
Call MMInfo_Insert (1339,32536,'在线签到考勤','/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet','mainFrame',47,2,1,0,'',0,'',0,'','',0,'','',2)
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmOrgGroupList' WHERE id =871
/

Delete from MainMenuInfo where id=85
/
Call MMConfig_U_ByInfoInsert (47,18)
/
Call MMInfo_Insert (85,16750,'','/hrm/HrmTab.jsp?_fromURL=HrmPubHoliday','mainFrame',47,2,18,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=86
/
Call MMConfig_U_ByInfoInsert (47,19)
/
Call MMInfo_Insert (86,16255,'','/hrm/HrmTab.jsp?_fromURL=HrmArrangeShiftList','mainFrame',47,2,19,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=87
/
Call MMConfig_U_ByInfoInsert (47,20)
/
Call MMInfo_Insert (87,16256,'','/hrm/HrmTab.jsp?_fromURL=HrmArrangeShiftMaintanceFrm','mainFrame',47,2,20,0,'',1,'HrmArrangeShiftMaintance:Maintance',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=82
/
Delete from MainMenuInfo where id=1346
/
Call MMConfig_U_ByInfoInsert (1344,0)
/
Call MMInfo_Insert (1346,6139,'考勤种类','/hrm/schedule/HrmScheduleDiff_frm.jsp','mainFrame',1344,3,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1349
/
Call MMConfig_U_ByInfoInsert (1344,1)
/
Call MMInfo_Insert (1349,19397,'','/hrm/schedule/HrmScheduleMonth_frm.jsp','mainFrame',1344,3,1,0,'',0,'',0,'','',0,'','',2)
/ 
Delete from MainMenuInfo where id=105
/
Call MMConfig_U_ByInfoInsert (51,0)
/
Call MMInfo_Insert (105,6130,'','/hrm/HrmTab.jsp?_fromURL=HrmTrainType','mainFrame',51,2,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=106
/
Call MMConfig_U_ByInfoInsert (51,2)
/
Call MMInfo_Insert (106,6128,'','/hrm/HrmTab.jsp?_fromURL=HrmTrainLayout','mainFrame',51,2,2,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=107
/
Call MMConfig_U_ByInfoInsert (51,3)
/
Call MMInfo_Insert (107,15879,'','/hrm/HrmTab.jsp?_fromURL=HrmTrainResource','mainFrame',51,2,3,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=108
/
Call MMConfig_U_ByInfoInsert (51,4)
/
Call MMInfo_Insert (108,6156,'','/hrm/HrmTab.jsp?_fromURL=HrmTrainPlan','mainFrame',51,2,4,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=44
/
Call MMConfig_U_ByInfoInsert (3,6)
/
Call MMInfo_Insert (44,16455,'','','',3,1,6,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=55
/
Call MMConfig_U_ByInfoInsert (44,-1)
/
Call MMInfo_Insert (55,32498,'列表式编辑','/hrm/company/HrmCompany.jsp','mainFrame',44,2,-1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=110
/
Call MMConfig_U_ByInfoInsert (52,0)
/
Call MMInfo_Insert (110,6099,'','/hrm/HrmTab.jsp?_fromURL=HrmAwardType','mainFrame',52,2,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=111
/
Call MMConfig_U_ByInfoInsert (52,1)
/
Call MMInfo_Insert (111,6100,'','/hrm/HrmTab.jsp?_fromURL=HrmAward','mainFrame',52,2,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=112
/
Call MMConfig_U_ByInfoInsert (52,1)
/
Call MMInfo_Insert (112,6118,'','/hrm/HrmTab.jsp?_fromURL=HrmCheckKind','mainFrame',52,2,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from LeftMenuInfo where id=49
/
Call LMConfig_U_ByInfoInsert (2,5,29)
/
Call LMInfo_Insert (49,16418,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_8.gif','/hrm/HrmTab.jsp?_fromURL=HrmResourceSearch',2,5,29,2) 
/
Delete from LeftMenuInfo where id=49
/
Call LMConfig_U_ByInfoInsert (2,5,29)
/
Call LMInfo_Insert (49,16418,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_8.gif','/hrm/HrmTab.jsp?_fromURL=HrmResourceSearch',2,5,29,2)
/
Delete from MainMenuInfo where id=103
/
Call MMConfig_U_ByInfoInsert (50,9)
/
Call MMInfo_Insert (103,15812,'','/hrm/HrmTab.jsp?_fromURL=HrmBankList','mainFrame',50,2,9,0,'',0,'',0,'','',0,'','',2)
/
UPDATE  MainMenuInfo SET labelId=33399 WHERE id =526
/
UPDATE  MainMenuInfo SET labelId=33398 WHERE id =105
/
UPDATE  MainMenuInfo SET labelId=33397 WHERE id =102
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmSalaryChange' WHERE id =526
/

Delete from LeftMenuInfo where id=43
/
Call LMConfig_U_ByInfoInsert (2,5,6)
/
Call LMInfo_Insert (43,16415,'/images_face/ecologyFace_2/LeftMenuIcon/HRM_43.png','/hrm/hrmTab.jsp?_fromURL=HrmResource',2,5,6,2)
/
Delete from LeftMenuInfo where id=43
/
Call LMConfig_U_ByInfoInsert (2,5,6)
/
Call LMInfo_Insert (43,16415,'/images_face/ecologyFace_2/LeftMenuIcon/HRM_43.png','/hrm/hrmTab.jsp?_fromURL=HrmResource',2,5,6,2)
/
Delete from MainMenuInfo where id=87
/
Call MMConfig_U_ByInfoInsert (47,23)
/
Call MMInfo_Insert (87,16256,'','/hrm/schedule/HrmArrangeShiftMaintanceFrm.jsp','mainFrame',47,2,23,0,'',1,'HrmArrangeShiftMaintance:Maintance',0,'','',0,'','',2)
/
UPDATE  MainMenuInfo SET linkAddress = '/hrm/HrmTab.jsp?_fromURL=BirthdaySetting' WHERE id =1304
/

UPDATE LeftMenuInfo SET labelId =16065 where id = 48
/
Delete from MainMenuInfo where id=312
/
Call MMConfig_U_ByInfoInsert (220,0)
/
Call MMInfo_Insert (312,16564,'','/hrm/HrmTab.jsp?_fromURL=HrmRpRedeploy','mainFrame',220,3,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=319
/
Call MMConfig_U_ByInfoInsert (220,6)
/
Call MMInfo_Insert (319,16571,'','/hrm/HrmTab.jsp?_fromURL=HrmRpFire','mainFrame',220,3,6,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=318
/
Call MMConfig_U_ByInfoInsert (220,6)
/
Call MMInfo_Insert (318,16570,'','/hrm/HrmTab.jsp?_fromURL=HrmRpDismiss','mainFrame',220,3,6,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=317
/
Call MMConfig_U_ByInfoInsert (220,5)
/
Call MMInfo_Insert (317,16569,'','/hrm/HrmTab.jsp?_fromURL=HrmRpRetire','mainFrame',220,3,5,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=316
/
Call MMConfig_U_ByInfoInsert (220,4)
/
Call MMInfo_Insert (316,16568,'','/hrm/HrmTab.jsp?_fromURL=HrmRpRehire','mainFrame',220,3,4,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=315
/
Call MMConfig_U_ByInfoInsert (220,3)
/
Call MMInfo_Insert (315,16567,'','/hrm/HrmTab.jsp?_fromURL=HrmRpExtend','mainFrame',220,3,3,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=314
/
Call MMConfig_U_ByInfoInsert (220,2)
/
Call MMInfo_Insert (314,16566,'','/hrm/HrmTab.jsp?_fromURL=HrmRpHire','mainFrame',220,3,2,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=313
/
Call MMConfig_U_ByInfoInsert (220,1)
/
Call MMInfo_Insert (313,16565,'','/hrm/HrmTab.jsp?_fromURL=HrmRpResourceAdd','mainFrame',220,3,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=312
/
Call MMConfig_U_ByInfoInsert (220,-1)
/
Call MMInfo_Insert (312,16564,'','/hrm/HrmTab.jsp?_fromURL=HrmRpRedeploy','mainFrame',220,3,-1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1393
/
Call MMConfig_U_ByInfoInsert (222,1)
/
Call MMInfo_Insert (1393,6131,'用工需求','/hrm/HrmTab.jsp?_fromURL=HrmRpUseDemand','mainFrame',222,3,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=321
/
Call MMConfig_U_ByInfoInsert (222,1)
/
Call MMInfo_Insert (321,15885,'','/hrm/HrmTab.jsp?_fromURL=HrmRpCareerApply','mainFrame',222,3,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=81
/
Call MMConfig_U_ByInfoInsert (47,4)
/
Call MMInfo_Insert (81,16738,'','','mainFrame',47,2,4,0,'',1,'HrmkqSystemSetEdit:Edit',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1339
/
Call MMConfig_U_ByInfoInsert (47,3)
/
Call MMInfo_Insert (1339,33545,'在线签到考勤','/hrm/HrmTab.jsp?_fromURL=HrmOnlineKqSystemSet','mainFrame',47,2,3,0,'',1,'HrmkqSystemSetEdit:Edit',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1395
/
Call MMConfig_U_ByInfoInsert (47,4)
/
Call MMInfo_Insert (1395,33548,'外部集成考勤','','',47,2,4,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1396
/
Call MMConfig_U_ByInfoInsert (1395,1)
/
Call MMInfo_Insert (1396,33539,'考勤外部数据导入','/hrm/HrmTab.jsp?_fromURL=HrmScheduleSignImport','mainFrame',1395,3,1,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=1397
/
Call MMConfig_U_ByInfoInsert (1395,0)
/
Call MMInfo_Insert (1397,33459,'考勤外部数同步设置','/hrm/HrmTab.jsp?_fromURL=HrmScheduleSignDataSourceSet','mainFrame',1395,3,0,0,'',0,'',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=94
/
Delete from MainMenuInfo where id=45
/
Call MMConfig_U_ByInfoInsert (3,-1)
/
Call MMInfo_Insert (45,16484,'基础设置','','',3,1,-1,0,'',0,'',0,'','',0,'','',2)
/

UPDATE  MainMenuInfo SET defaultIndex =3 WHERE id =112
/
UPDATE  MainMenuInfo SET defaultIndex =1 WHERE id =111
/
UPDATE  mainMenuConfig SET viewindex =infoId WHERE infoId IN(110,111,112,113,114)
/

Delete from MainMenuInfo where id=15
/
Call MMConfig_U_ByInfoInsert (3,8)
/
Call MMInfo_Insert (15,16627,'','/docs/docs/Signature_frm.jsp','mainFrame',3,1,8,0,'',1,'SignatureList:List',0,'','',0,'','',2)
/
Delete from MainMenuInfo where id=426
/
Call MMConfig_U_ByInfoInsert (11,47)
/
Call MMInfo_Insert (426,18014,'授权信息','/hrm/HrmTab.jsp?_fromURL=licenseInfo','mainFrame',11,1,47,0,'',0,'',0,'','',0,'','',9)
/

Delete from MainMenuInfo where id=1344
/
Call MMConfig_U_ByInfoInsert (47,3)
/
Call MMInfo_Insert (1344,0,'','','mainFrame',47,2,3,0,'',0,'',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=1344
/
Call MMConfig_U_ByInfoInsert (47,3)
/
Call MMInfo_Insert (1344,33067,'','','mainFrame',47,2,3,0,'',0,'',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=1344
/
Call MMConfig_U_ByInfoInsert (47,1)
/
Call MMInfo_Insert (1344,33067,'','','mainFrame',47,2,1,0,'',0,'',0,'','',0,'','',2)
/

Delete from MainMenuInfo where id=109
/
Call MMConfig_U_ByInfoInsert (51,5)
/
Call MMInfo_Insert (109,6136,'','/hrm/HrmTab.jsp?_fromURL=HrmTrain','mainFrame',51,2,5,0,'',0,'',0,'','',0,'','',2)
/
