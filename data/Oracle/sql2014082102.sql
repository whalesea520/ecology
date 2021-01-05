Delete from MainMenuInfo where id=1324
/
CALL MMConfig_U_ByInfoInsert (8,2)
/
CALL MMInfo_Insert (1324,32722,'资产类型设置','/cpt/maintenance/CptCapitalType.jsp','mainFrame',8,1,2,0,'',0,'',0,'','',0,'','',7)
/



Delete from MainMenuInfo where id=1325
/
CALL MMConfig_U_ByInfoInsert (8,3)
/
CALL MMInfo_Insert (1325,32723,'资产资料编码设置','/cpt/coding/CapitalCodingData1.jsp','mainFrame',8,1,3,0,'',0,'',0,'','',0,'','',7)
/



update MainMenuInfo set labelId=32470 where id=171
/
delete MainMenuInfo where id=174
/



Delete from MainMenuInfo where id=1326
/
CALL MMConfig_U_ByInfoInsert (171,4)
/
CALL MMInfo_Insert (1326,32724,'资产资料页面布局','/cpt/layout/CptData1HtmlSet.jsp','mainFrame',171,2,4,0,'',0,'',0,'','',0,'','',7)
/



Delete from MainMenuInfo where id=1327
/
CALL MMConfig_U_ByInfoInsert (171,5)
/
CALL MMInfo_Insert (1327,32725,'资产卡片页面布局','/cpt/layout/CptHtmlSet.jsp','mainFrame',171,2,5,0,'',0,'',0,'','',0,'','',7)
/




Delete from LeftMenuInfo where id=593
/
CALL LMConfig_U_ByInfoInsert (2,7,5)
/
CALL LMInfo_Insert (593,15306,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalInstock1.jsp',2,7,5,7 )
/
Delete from LeftMenuInfo where id=594
/
CALL LMConfig_U_ByInfoInsert (2,7,6)
/
CALL LMInfo_Insert (594,15307,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptInstockSearch.jsp',2,7,6,7 )
/
Delete from LeftMenuInfo where id=595
/
CALL LMConfig_U_ByInfoInsert (2,7,7)
/
CALL LMInfo_Insert (595,32726,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','',2,7,7,7 )
/

Delete from LeftMenuInfo where id=596
/
CALL LMConfig_U_ByInfoInsert (2,595,8)
/
CALL LMInfo_Insert (596,886,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalUse.jsp',2,595,8,7 )
/
Delete from LeftMenuInfo where id=597
/
CALL LMConfig_U_ByInfoInsert (2,595,9)
/
CALL LMInfo_Insert (597,883,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalMove.jsp',2,595,9,7 )
/
Delete from LeftMenuInfo where id=598
/
CALL LMConfig_U_ByInfoInsert (2,595,10)
/
CALL LMInfo_Insert (598,6051,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalLend.jsp',2,595,10,7 )
/
Delete from LeftMenuInfo where id=599
/
CALL LMConfig_U_ByInfoInsert (2,595,11)
/
CALL LMInfo_Insert (599,6054,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalLoss.jsp',2,595,11,7 )
/
Delete from LeftMenuInfo where id=600
/
CALL LMConfig_U_ByInfoInsert (2,595,12)
/
CALL LMInfo_Insert (600,6052,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalDiscard.jsp',2,595,12,7 )
/
Delete from LeftMenuInfo where id=601
/
CALL LMConfig_U_ByInfoInsert (2,595,13)
/
CALL LMInfo_Insert (601,22459,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalMend.jsp',2,595,13,7 )
/
Delete from LeftMenuInfo where id=602
/
CALL LMConfig_U_ByInfoInsert (2,595,14)
/
CALL LMInfo_Insert (602,15305,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalBack.jsp?isfromwf=1',2,595,14,7 )
/

delete from MainMenuInfo where defaultparentid=173
/
delete from MainMenuInfo where id=173
/
delete from MainMenuInfo where id=173
/
delete from MainMenuInfo where id=175
/

Delete from MainMenuInfo where id=1328
/
CALL MMConfig_U_ByInfoInsert (492,10)
/
CALL MMInfo_Insert (1328,16511,'单位设置','/lgc/maintenance/LgcAssetUnit.jsp','mainFrame',492,1,10,0,'',0,'',0,'','',0,'','',9)
/

update MainMenuInfo set labelId=19314,linkAddress='/cpt/capital/CapitalExcelToDB1.jsp' where labelId=19320
/

Delete from LeftMenuInfo where id=612
/
CALL LMConfig_U_ByInfoInsert (2,7,5)
/
CALL LMInfo_Insert (612,33182,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptSearch.jsp?isdata=1',2,7,5,7 )
/

Delete from LeftMenuInfo where id=612
/
CALL LMConfig_U_ByInfoInsert (2,7,5)
/
CALL LMInfo_Insert (612,33182,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptSearch.jsp?isdata=1',2,7,5,7 )
/

update leftmenuinfo set iconUrl='' where parentId=595
/

update MainMenuInfo set labelId=19320,linkAddress='/cpt/capital/CapitalExcelToDB.jsp' where labelId=19314
/

Delete from MainMenuInfo where id=1387
/
CALL MMConfig_U_ByInfoInsert (8,12)
/
CALL MMInfo_Insert (1387,19314,'资产导入','/cpt/capital/CapitalExcelToDB1.jsp','mainFrame',8,1,12,0,'',0,'',0,'','',0,'','',7)
/











update MainMenuInfo set defaultParentId=377,defaultLevel=2,defaultIndex=1,parentId=377 where id=161
/
update mainmenuconfig set viewIndex='1' where infoId=161
/
update MainMenuInfo set defaultParentId=377,defaultLevel=2,defaultIndex=2,parentId=377 where id=162
/
update mainmenuconfig set viewIndex='2' where infoId=162
/
delete mainmenuinfo where id=1267
/
delete mainmenuinfo where id=906
/
delete mainmenuinfo where id=380
/
update mainmenuinfo set labelId='33090',menuName='模板维护' where id=381
/
update MainMenuInfo set labelId='33091',menuName='通用项目自定义字段',defaultParentId=1353,defaultLevel=2,defaultIndex=1,parentId=1353 where id=163
/


Delete from MainMenuInfo where id=1353
/
CALL MMConfig_U_ByInfoInsert (6,6)
/
CALL MMInfo_Insert (1353,32470,'自定义设置','','mainFrame',6,1,6,0,'',0,'',0,'','',0,'','',5)
/

Delete from MainMenuInfo where id=1354
/
CALL MMConfig_U_ByInfoInsert (6,6)
/
CALL MMInfo_Insert (1354,18630,'项目类型自定义字段','/proj/ffield/ProjTypeFreefieldTab.jsp','mainFrame',6,1,6,0,'',0,'',0,'','',0,'','',5)
/
update MainMenuInfo set menuName='通用项目自定义字段',defaultParentId=1353,defaultLevel=2,defaultIndex=2,parentId=1353 where id=1354
/

Delete from MainMenuInfo where id=1355
/
CALL MMConfig_U_ByInfoInsert (6,8)
/
CALL MMInfo_Insert (1355,31811,'应用设置','/proj/Maint/PrjAppSetting.jsp','mainFrame',6,1,8,0,'',0,'',0,'','',0,'','',5)
/

update LeftMenuInfo set labelId='33103',defaultIndex=1 where id=39
/
update  LeftMenuConfig set viewindex='1' where infoId=39
/
update LeftMenuInfo set linkAddress='/proj/data/MyManagerProject.jsp',labelId='1211',defaultIndex=3 where id=40
/
update  LeftMenuConfig set viewindex='3' where infoId=40
/
update LeftMenuInfo set defaultIndex=4 where id=35
/
update  LeftMenuConfig set viewindex='4' where infoId=35
/
delete from LeftMenuInfo where id=37
/
update LeftMenuInfo set defaultIndex=5 where id=38
/
update  LeftMenuConfig set viewindex='5' where infoId=38
/
update LeftMenuInfo set defaultIndex=10 where id=216
/
update  LeftMenuConfig set viewindex='10' where infoId=216
/

update MainMenuInfo set linkAddress='/proj/coding/PrjCoding.jsp' where id=378
/









delete from  LeftMenuInfo where id=201
/


















































