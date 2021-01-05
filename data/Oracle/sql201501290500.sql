delete from SystemRightDetail where rightid =1804
/
delete from SystemRightsLanguage where id =1804
/
delete from SystemRights where id =1804
/
insert into SystemRights (id,rightdesc,righttype) values (1804,'会议卡片自定义设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,9,'会议卡片自定义设置','会议卡片自定义设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,7,'会议卡片自定义设置','会议卡片自定义设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,8,'Meeting Custom Defined','Meeting Custom Defined') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,10,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43037,'会议卡片自定义字段','Meeting:fieldDefined',1804) 
/

delete from SystemRightDetail where rightid =1810
/
delete from SystemRightsLanguage where id =1810
/
delete from SystemRights where id =1810
/
insert into SystemRights (id,rightdesc,righttype) values (1810,'会议服务设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,7,'会议服务设置','会议服务设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,9,'会议服务设置','会议服务设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,8,'Meeting Service Set','Meeting Service Set') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,10,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43043,'会议服务设置','Meeting:Service',1810) 
/

delete from SystemRightDetail where rightid =1815
/
delete from SystemRightsLanguage where id =1815
/
delete from SystemRights where id =1815
/
insert into SystemRights (id,rightdesc,righttype) values (1815,'会议提醒模板','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,8,'Meeting Remind Template','Meeting Remind Template') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,7,'会议提醒模板','会议提醒模板') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,9,'会议提醒模板','会议提醒模板') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43047,'会议提醒模板','Meeting:Remind',1815) 
/

delete from SystemRightDetail where rightid =1816
/
delete from SystemRightsLanguage where id =1816
/
delete from SystemRights where id =1816
/
insert into SystemRights (id,rightdesc,righttype) values (1816,'会议流程设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,7,'会议流程设置','会议流程设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,8,'Meeting WF Set','Meeting WF Set') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,9,'會議流程設置','會議流程設置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43048,'会议流程设置','Meeting:WFSetting',1816) 
/

