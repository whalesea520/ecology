delete from SystemRightDetail where rightid =457
/
delete from SystemRightsLanguage where id =457
/
delete from SystemRights where id =457
/
insert into SystemRights (id,rightdesc,righttype) values (457,'知识积累创新报表查看权限','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'知识积累创新报表查看权限','知识积累创新报表查看权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'doccreativereport','doccreativereport') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'知识积累创新报表查看权限','docactiverep:view',457) 
/
delete from SystemRightDetail where rightid =454
/
delete from SystemRightsLanguage where id =454
/
delete from SystemRights where id =454
/
insert into SystemRights (id,rightdesc,righttype) values (454,'hrm其他设置维护','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,7,'hrm其他设置维护','hrm其他设置维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,8,'hrm other settings maintenance','hrm other settings maintenance') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3145,'hrm其他设置编辑','OtherSettings:Edit',454) 
/
delete from SystemRightDetail where rightid =462
/
delete from SystemRightsLanguage where id =462
/
delete from SystemRights where id =462
/
insert into SystemRights (id,rightdesc,righttype) values (462,'hrm自定义组维护','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,7,'hrm自定义组维护','hrm自定义组维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,8,'hrm custom group maintenance','hrm custom group maintenance') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3154,'hrm自定义组编辑','CustomGroup:Edit',462) 
/
delete from SystemRightDetail where rightid =464
/
delete from SystemRightsLanguage where id =464
/
delete from SystemRights where id =464
/
insert into SystemRights (id,rightdesc,righttype) values (464,'离职处理','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,8,'dimission management','dimission management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,7,'离职处理','离职处理') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3156,'hrm人员离职处理','Resign:Main',464) 
/
delete from SystemRightDetail where rightid =702
/
delete from SystemRightsLanguage where id =702
/
delete from SystemRights where id =702
/
insert into SystemRights (id,rightdesc,righttype) values (702,'工时标准设置','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,7,'工时标准设置','工时标准设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,8,'work hours standard settings','work hours standard settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4210,'工时标准设置','TIMESET',702) 
/