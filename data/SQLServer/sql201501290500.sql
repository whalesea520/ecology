delete from SystemRightDetail where rightid =1804
GO
delete from SystemRightsLanguage where id =1804
GO
delete from SystemRights where id =1804
GO
insert into SystemRights (id,rightdesc,righttype) values (1804,'���鿨Ƭ�Զ�������','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,9,'���鿨Ƭ�Զ�������','���鿨Ƭ�Զ�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,7,'���鿨Ƭ�Զ�������','���鿨Ƭ�Զ�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,8,'Meeting Custom Defined','Meeting Custom Defined') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1804,10,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43037,'���鿨Ƭ�Զ����ֶ�','Meeting:fieldDefined',1804) 
GO

delete from SystemRightDetail where rightid =1810
GO
delete from SystemRightsLanguage where id =1810
GO
delete from SystemRights where id =1810
GO
insert into SystemRights (id,rightdesc,righttype) values (1810,'�����������','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,7,'�����������','�����������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,9,'�����������','�����������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,8,'Meeting Service Set','Meeting Service Set') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1810,10,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43043,'�����������','Meeting:Service',1810) 
GO

delete from SystemRightDetail where rightid =1815
GO
delete from SystemRightsLanguage where id =1815
GO
delete from SystemRights where id =1815
GO
insert into SystemRights (id,rightdesc,righttype) values (1815,'��������ģ��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,10,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,8,'Meeting Remind Template','Meeting Remind Template') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,7,'��������ģ��','��������ģ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1815,9,'��������ģ��','��������ģ��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43047,'��������ģ��','Meeting:Remind',1815) 
GO

delete from SystemRightDetail where rightid =1816
GO
delete from SystemRightsLanguage where id =1816
GO
delete from SystemRights where id =1816
GO
insert into SystemRights (id,rightdesc,righttype) values (1816,'������������','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,7,'������������','������������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,10,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,8,'Meeting WF Set','Meeting WF Set') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1816,9,'���h�����O��','���h�����O��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43048,'������������','Meeting:WFSetting',1816) 
GO
