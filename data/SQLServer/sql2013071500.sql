delete from SystemRightDetail where rightid =457
GO
delete from SystemRightsLanguage where id =457
GO
delete from SystemRights where id =457
GO
insert into SystemRights (id,rightdesc,righttype) values (457,'֪ʶ���۴��±����鿴Ȩ��','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,7,'֪ʶ���۴��±����鿴Ȩ��','֪ʶ���۴��±����鿴Ȩ��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (457,8,'doccreativereport','doccreativereport') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3148,'֪ʶ���۴��±����鿴Ȩ��','docactiverep:view',457) 
GO
delete from SystemRightDetail where rightid =454
GO
delete from SystemRightsLanguage where id =454
GO
delete from SystemRights where id =454
GO
insert into SystemRights (id,rightdesc,righttype) values (454,'hrm��������ά��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,7,'hrm��������ά��','hrm��������ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,8,'hrm other settings maintenance','hrm other settings maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3145,'hrm�������ñ༭','OtherSettings:Edit',454) 
GO
delete from SystemRightDetail where rightid =462
GO
delete from SystemRightsLanguage where id =462
GO
delete from SystemRights where id =462
GO
insert into SystemRights (id,rightdesc,righttype) values (462,'hrm�Զ�����ά��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,7,'hrm�Զ�����ά��','hrm�Զ�����ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (462,8,'hrm custom group maintenance','hrm custom group maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3154,'hrm�Զ�����༭','CustomGroup:Edit',462) 
GO
delete from SystemRightDetail where rightid =464
GO
delete from SystemRightsLanguage where id =464
GO
delete from SystemRights where id =464
GO
insert into SystemRights (id,rightdesc,righttype) values (464,'��ְ����','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,8,'dimission management','dimission management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (464,7,'��ְ����','��ְ����') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3156,'hrm��Ա��ְ����','Resign:Main',464) 
GO
delete from SystemRightDetail where rightid =702
GO
delete from SystemRightsLanguage where id =702
GO
delete from SystemRights where id =702
GO
insert into SystemRights (id,rightdesc,righttype) values (702,'��ʱ��׼����','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,7,'��ʱ��׼����','��ʱ��׼����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (702,8,'work hours standard settings','work hours standard settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4210,'��ʱ��׼����','TIMESET',702) 
GO