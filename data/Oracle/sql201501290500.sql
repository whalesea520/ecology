delete from SystemRightDetail where rightid =1804
/
delete from SystemRightsLanguage where id =1804
/
delete from SystemRights where id =1804
/
insert into SystemRights (id,rightdesc,righttype) values (1804,'���鿨Ƭ�Զ�������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,9,'���鿨Ƭ�Զ�������','���鿨Ƭ�Զ�������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,7,'���鿨Ƭ�Զ�������','���鿨Ƭ�Զ�������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,8,'Meeting Custom Defined','Meeting Custom Defined') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,10,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43037,'���鿨Ƭ�Զ����ֶ�','Meeting:fieldDefined',1804) 
/

delete from SystemRightDetail where rightid =1810
/
delete from SystemRightsLanguage where id =1810
/
delete from SystemRights where id =1810
/
insert into SystemRights (id,rightdesc,righttype) values (1810,'�����������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,7,'�����������','�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,9,'�����������','�����������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,8,'Meeting Service Set','Meeting Service Set') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,10,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43043,'�����������','Meeting:Service',1810) 
/

delete from SystemRightDetail where rightid =1815
/
delete from SystemRightsLanguage where id =1815
/
delete from SystemRights where id =1815
/
insert into SystemRights (id,rightdesc,righttype) values (1815,'��������ģ��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,8,'Meeting Remind Template','Meeting Remind Template') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,7,'��������ģ��','��������ģ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,9,'��������ģ��','��������ģ��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43047,'��������ģ��','Meeting:Remind',1815) 
/

delete from SystemRightDetail where rightid =1816
/
delete from SystemRightsLanguage where id =1816
/
delete from SystemRights where id =1816
/
insert into SystemRights (id,rightdesc,righttype) values (1816,'������������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,7,'������������','������������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,10,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,8,'Meeting WF Set','Meeting WF Set') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,9,'���h�����O��','���h�����O��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43048,'������������','Meeting:WFSetting',1816) 
/
