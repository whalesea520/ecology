INSERT INTO SystemModule VALUES (14,'邮件管理',1)
GO
INSERT INTO SystemModule VALUES (15,'会议管理',1)
GO
INSERT INTO SystemModule VALUES (16,'日程管理',1)
GO
INSERT INTO SystemModule VALUES (17,'通信管理',1)
GO
INSERT INTO SystemModule VALUES (18,'工作微博',1)
GO
INSERT INTO SystemModule VALUES (19,'公文管理',1)
GO
INSERT INTO SystemModule VALUES (20,'网上调查',1)
GO
INSERT INTO SystemModule VALUES (21,'车辆管理',1)
GO
INSERT INTO SystemModule VALUES (22,'相册管理',1)
GO
INSERT INTO SystemModule VALUES (23,'集成中心',1)
GO
INSERT INTO SystemModule VALUES (24,'协同区',1)
GO
INSERT INTO SystemModule VALUES (25,'证照管理',1)
GO
INSERT INTO SystemModule VALUES (26,'建模引擎',1)
GO
INSERT INTO SystemModule VALUES (27,'移动引擎',1)
GO
INSERT INTO SystemModule VALUES (28,'应用中心',1)
GO


update MainMenuInfo set relatedModuleId = 2 where id= 10000
GO
update MainMenuInfo set relatedModuleId = 3 where id= 10001
GO
update MainMenuInfo set relatedModuleId = 13 where id= 10002
GO
update MainMenuInfo set relatedModuleId = 1 where id= 10003
GO
update MainMenuInfo set relatedModuleId = 28 where id= 10004
GO
update MainMenuInfo set relatedModuleId = 26 where id= 10005
GO
update MainMenuInfo set relatedModuleId = 27 where id= 10006
GO
update MainMenuInfo set relatedModuleId = 23 where id= 10007
GO
update MainMenuInfo set relatedModuleId = 9 where id= 10008
GO
update MainMenuInfo set relatedModuleId = 9 where id= 10009
GO
update MainMenuInfo set relatedModuleId = 9 where id= 10010
GO

update MainMenuInfo set relatedModuleId = 15 where id= 502
GO
update MainMenuInfo set relatedModuleId = 16 where id= 546
GO
update MainMenuInfo set relatedModuleId = 17 where id= 1329
GO
update MainMenuInfo set relatedModuleId = 14 where id= 1381
GO
update MainMenuInfo set relatedModuleId = 18 where id= 1047
GO
update MainMenuInfo set relatedModuleId = 19 where id= 1366
GO
update MainMenuInfo set relatedModuleId = 20 where id= 10086
GO
update MainMenuInfo set relatedModuleId = 21 where id= 364
GO
update MainMenuInfo set relatedModuleId = 24 where id= 1336
GO
update MainMenuInfo set relatedModuleId = 25 where id= 1255
GO