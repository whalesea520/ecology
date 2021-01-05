delete from SystemRightDetail where rightid =56
/
delete from SystemRightsLanguage where id =56
/
delete from SystemRights where id =56
/
insert into SystemRights (id,rightdesc,righttype) values (56,'项目状态维护','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,7,'项目状态维护','项目状态的添加，删除，更新和日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (56,8,'ProjectStatus Maintenance','Add,delete,update and log ProjectStatus') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (202,'项目状态添加','AddProjectStatus:Add',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (203,'项目状态编辑','EditProjectStatus:Edit',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (204,'项目状态删除','EditProjectStatus:Delete',56) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (205,'项目状态日志查看','ProjectStatus:Log',56) 
/
delete from SystemRightsLanguage where id =1811
/
delete from SystemRights where id =1811
/
insert into SystemRights (id,rightdesc,righttype) values (1811,'项目流程设置','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,9,'項目流程設置','項目流程設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,7,'项目流程设置','项目流程设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1811,8,'Project Workflow Settings','Project Workflow Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41811,'项目流程设置权限','Prj:WorkflowSetting',1811) 
/