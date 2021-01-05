delete from SystemRightDetail where rightid =457
GO
delete from SystemRightsLanguage where id =457
GO
delete from SystemRights where id =457
GO
insert into SystemRights (id,rightdesc,righttype) values (457,'知识积累创新报表查看权限','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'知识积累创新报表查看权限','知识积累创新报表查看权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'doccreativereport','doccreativereport') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'知识积累创新报表查看权限','docactiverep:view',457) 
GO
delete from SystemRightDetail where rightid =454
GO
delete from SystemRightsLanguage where id =454
GO
delete from SystemRights where id =454
GO
insert into SystemRights (id,rightdesc,righttype) values (454,'hrm其他设置维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,7,'hrm其他设置维护','hrm其他设置维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,8,'hrm other settings maintenance','hrm other settings maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3145,'hrm其他设置编辑','OtherSettings:Edit',454) 
GO
delete from SystemRightDetail where rightid =462
GO
delete from SystemRightsLanguage where id =462
GO
delete from SystemRights where id =462
GO
insert into SystemRights (id,rightdesc,righttype) values (462,'hrm自定义组维护','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,7,'hrm自定义组维护','hrm自定义组维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,8,'hrm custom group maintenance','hrm custom group maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3154,'hrm自定义组编辑','CustomGroup:Edit',462) 
GO
delete from SystemRightDetail where rightid =464
GO
delete from SystemRightsLanguage where id =464
GO
delete from SystemRights where id =464
GO
insert into SystemRights (id,rightdesc,righttype) values (464,'离职处理','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,8,'dimission management','dimission management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,7,'离职处理','离职处理') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3156,'hrm人员离职处理','Resign:Main',464) 
GO
delete from SystemRightDetail where rightid =702
GO
delete from SystemRightsLanguage where id =702
GO
delete from SystemRights where id =702
GO
insert into SystemRights (id,rightdesc,righttype) values (702,'工时标准设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,7,'工时标准设置','工时标准设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,8,'work hours standard settings','work hours standard settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4210,'工时标准设置','TIMESET',702) 
GO