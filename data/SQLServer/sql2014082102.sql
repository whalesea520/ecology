Delete from MainMenuInfo where id=1324
GO
EXECUTE MMConfig_U_ByInfoInsert 8,2
GO
EXECUTE MMInfo_Insert 1324,32722,'资产类型设置','/cpt/maintenance/CptCapitalType.jsp','mainFrame',8,1,2,0,'',0,'',0,'','',0,'','',7
GO



Delete from MainMenuInfo where id=1325
GO
EXECUTE MMConfig_U_ByInfoInsert 8,3
GO
EXECUTE MMInfo_Insert 1325,32723,'资产资料编码设置','/cpt/coding/CapitalCodingData1.jsp','mainFrame',8,1,3,0,'',0,'',0,'','',0,'','',7
GO



update MainMenuInfo set labelId=32470 where id=171
GO
delete MainMenuInfo where id=174
GO



Delete from MainMenuInfo where id=1326
GO
EXECUTE MMConfig_U_ByInfoInsert 171,4
GO
EXECUTE MMInfo_Insert 1326,32724,'资产资料页面布局','/cpt/layout/CptData1HtmlSet.jsp','mainFrame',171,2,4,0,'',0,'',0,'','',0,'','',7
GO



Delete from MainMenuInfo where id=1327
GO
EXECUTE MMConfig_U_ByInfoInsert 171,5
GO
EXECUTE MMInfo_Insert 1327,32725,'资产卡片页面布局','/cpt/layout/CptHtmlSet.jsp','mainFrame',171,2,5,0,'',0,'',0,'','',0,'','',7
GO




Delete from LeftMenuInfo where id=593
GO
EXECUTE LMConfig_U_ByInfoInsert 2,7,5
GO
EXECUTE LMInfo_Insert 593,15306,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalInstock1.jsp',2,7,5,7 
GO
Delete from LeftMenuInfo where id=594
GO
EXECUTE LMConfig_U_ByInfoInsert 2,7,6
GO
EXECUTE LMInfo_Insert 594,15307,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptInstockSearch.jsp',2,7,6,7 
GO
Delete from LeftMenuInfo where id=595
GO
EXECUTE LMConfig_U_ByInfoInsert 2,7,7
GO
EXECUTE LMInfo_Insert 595,32726,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','',2,7,7,7 
GO

Delete from LeftMenuInfo where id=596
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,8
GO
EXECUTE LMInfo_Insert 596,886,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalUse.jsp',2,595,8,7 
GO
Delete from LeftMenuInfo where id=597
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,9
GO
EXECUTE LMInfo_Insert 597,883,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalMove.jsp',2,595,9,7 
GO
Delete from LeftMenuInfo where id=598
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,10
GO
EXECUTE LMInfo_Insert 598,6051,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalLend.jsp',2,595,10,7 
GO
Delete from LeftMenuInfo where id=599
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,11
GO
EXECUTE LMInfo_Insert 599,6054,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalLoss.jsp',2,595,11,7 
GO
Delete from LeftMenuInfo where id=600
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,12
GO
EXECUTE LMInfo_Insert 600,6052,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalDiscard.jsp',2,595,12,7 
GO
Delete from LeftMenuInfo where id=601
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,13
GO
EXECUTE LMInfo_Insert 601,22459,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalMend.jsp',2,595,13,7 
GO
Delete from LeftMenuInfo where id=602
GO
EXECUTE LMConfig_U_ByInfoInsert 2,595,14
GO
EXECUTE LMInfo_Insert 602,15305,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/capital/CptCapitalBack.jsp?isfromwf=1',2,595,14,7 
GO

delete from MainMenuInfo where defaultparentid=173
GO
delete from MainMenuInfo where id=173
GO
delete from MainMenuInfo where id=173
GO
delete from MainMenuInfo where id=175
GO

Delete from MainMenuInfo where id=1328
GO
EXECUTE MMConfig_U_ByInfoInsert 492,10
GO
EXECUTE MMInfo_Insert 1328,16511,'单位设置','/lgc/maintenance/LgcAssetUnit.jsp','mainFrame',492,1,10,0,'',0,'',0,'','',0,'','',9
GO

update MainMenuInfo set labelId=19314,linkAddress='/cpt/capital/CapitalExcelToDB1.jsp' where labelId=19320
go

Delete from LeftMenuInfo where id=612
GO
EXECUTE LMConfig_U_ByInfoInsert 2,7,5
GO
EXECUTE LMInfo_Insert 612,33182,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptSearch.jsp?isdata=1',2,7,5,7 
GO

Delete from LeftMenuInfo where id=612
GO
EXECUTE LMConfig_U_ByInfoInsert 2,7,5
GO
EXECUTE LMInfo_Insert 612,33182,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptSearch.jsp?isdata=1',2,7,5,7 
GO

update leftmenuinfo set iconUrl='' where parentId=595
go

update MainMenuInfo set labelId=19320,linkAddress='/cpt/capital/CapitalExcelToDB.jsp' where labelId=19314
go

Delete from MainMenuInfo where id=1387
GO
EXECUTE MMConfig_U_ByInfoInsert 8,12
GO
EXECUTE MMInfo_Insert 1387,19314,'资产导入','/cpt/capital/CapitalExcelToDB1.jsp','mainFrame',8,1,12,0,'',0,'',0,'','',0,'','',7
GO











update MainMenuInfo set defaultParentId=377,defaultLevel=2,defaultIndex=1,parentId=377 where id=161
go
update mainmenuconfig set viewIndex='1' where infoId=161
go
update MainMenuInfo set defaultParentId=377,defaultLevel=2,defaultIndex=2,parentId=377 where id=162
go
update mainmenuconfig set viewIndex='2' where infoId=162
go
delete mainmenuinfo where id=1267
go
delete mainmenuinfo where id=906
go
delete mainmenuinfo where id=380
go
update mainmenuinfo set labelId='33090',menuName='模板维护' where id=381
GO
update MainMenuInfo set labelId='33091',menuName='通用项目自定义字段',defaultParentId=1353,defaultLevel=2,defaultIndex=1,parentId=1353 where id=163
go


Delete from MainMenuInfo where id=1353
GO
EXECUTE MMConfig_U_ByInfoInsert 6,6
GO
EXECUTE MMInfo_Insert 1353,32470,'自定义设置','','mainFrame',6,1,6,0,'',0,'',0,'','',0,'','',5
GO

Delete from MainMenuInfo where id=1354
GO
EXECUTE MMConfig_U_ByInfoInsert 6,6
GO
EXECUTE MMInfo_Insert 1354,18630,'项目类型自定义字段','/proj/ffield/ProjTypeFreefieldTab.jsp','mainFrame',6,1,6,0,'',0,'',0,'','',0,'','',5
GO
update MainMenuInfo set menuName='通用项目自定义字段',defaultParentId=1353,defaultLevel=2,defaultIndex=2,parentId=1353 where id=1354
go

Delete from MainMenuInfo where id=1355
GO
EXECUTE MMConfig_U_ByInfoInsert 6,8
GO
EXECUTE MMInfo_Insert 1355,31811,'应用设置','/proj/Maint/PrjAppSetting.jsp','mainFrame',6,1,8,0,'',0,'',0,'','',0,'','',5
GO

update LeftMenuInfo set labelId='33103',defaultIndex=1 where id=39
go
update  LeftMenuConfig set viewindex='1' where infoId=39
go
update LeftMenuInfo set linkAddress='/proj/data/MyManagerProject.jsp',labelId='1211',defaultIndex=3 where id=40
go
update  LeftMenuConfig set viewindex='3' where infoId=40
go
update LeftMenuInfo set defaultIndex=4 where id=35
go
update  LeftMenuConfig set viewindex='4' where infoId=35
go
delete from LeftMenuInfo where id=37
GO
update LeftMenuInfo set defaultIndex=5 where id=38
go
update  LeftMenuConfig set viewindex='5' where infoId=38
go
update LeftMenuInfo set defaultIndex=10 where id=216
go
update  LeftMenuConfig set viewindex='10' where infoId=216
go

update MainMenuInfo set linkAddress='/proj/coding/PrjCoding.jsp' where id=378
go









delete from  LeftMenuInfo where id=201
go


















































