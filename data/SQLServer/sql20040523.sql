/*for id=69 by 王金永*/
update SystemRightsLanguage set rightdesc='分部的新建、编辑、显示、删除、查看日志' where id=18 and languageid=7
go
/*
BUG 79 具有职务类别权限的用户，没有权限查看职务类别的日志信息.但是系统管理员可以查看日志信息-黄煜
*/
Delete From SystemRightDetail Where rightid = 126
Go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (426,'职务类别添加','HrmJobGroupsAdd:Add',126) 
Go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (427,'职务类别编辑','HrmJobGroupsEdit:Edit',126) 
Go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (428,'职务类别删除','HrmJobGroupsEdit:Delete',126) 
Go
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (429,'职务类别日志查看','HrmJobGroups:Log',126) 
Go
/*
bug:92 修改112号权限的默认设置 by hy 
*/
DELETE FROM SystemRights WHERE id = 112
GO
DELETE FROM SystemRightsLanguage WHERE id = 112
GO
DELETE FROM SystemRightDetail WHERE rightid = 112
GO
insert into SystemRights (id,rightdesc,righttype) values (112,'其他信息维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,8,'other info maintenance','other info maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,7,'其他信息维护','其他信息维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (391,'其他信息添加','HrmOtherInfoTypeAdd:Add',112) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (392,'其他信息编辑','HrmOtherInfoTypeEdit:Edit',112) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (393,'其他信息删除','HrmOtherInfoTypeEdit:Delete',112) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (394,'其它信息日志查看','HrmOtherInfoType:Log',112) 
GO
/*更改默认权限为人力资源的总部级别*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=112
GO
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,112)
GO
DELETE FROM SystemRightRoles WHERE RightID = 112 and RoleID = 4
GO
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (112,4,2)
GO
