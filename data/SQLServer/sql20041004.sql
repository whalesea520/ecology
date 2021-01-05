/*td:78.695.696 "职务类别维护"权限在权限设置中显示的是"工作类型维护"; 将‘工作类别‘权限名称修改为’工作类型*/
delete SystemRights where id = 55 or id = 28
GO
delete SystemRightsLanguage where id =55 or id =28
GO
delete SystemRightDetail where rightid = 55 or rightid = 28 
GO
insert into SystemRights (id,rightdesc,righttype) values (55,'工作类型维护','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (55,8,'WorkType Maintenance','Add,delete,update and log WorkType') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (55,7,'工作类型维护','工作类型的添加，删除，更新和日志查看') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (198,'工作类型添加','AddWorkType:Add',55) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (199,'工作类型编辑','EditWorkType:Edit',55) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (200,'工作类型删除','EditWorkType:Delete',55) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (201,'工作类型日志查看','WorkType:Log',55) 
GO
insert into SystemRights (id,rightdesc,righttype) values (28,'职务类别维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,7,'职务类别维护','职务类别的添加，删除，更新和日志查看') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (28,8,'HrmJobGroups','Add,delete,update and log HrmJobGroups') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (96,'职务类别添加','HrmJobGroupsAdd:Add',28) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (97,'职务类别编辑','HrmJobGroupsEdit:Edit',28) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (98,'职务类别删除','HrmJobGroupsEdit:Delete',28) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (99,'职务类别日志查看','HrmJobGroups:Log',28) 
GO