delete from SystemRightDetail where rightid =1836
GO
delete from SystemRightsLanguage where id =1836
GO
delete from SystemRights where id =1836
GO
insert into SystemRights (id,rightdesc,righttype,detachable) values (1836,'���̽�������','5',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,10,'������� �ߧѧ����ۧܧ� �ܧ�ާާ��ѧ����','������� �ߧѧ����ۧܧ� �ܧ�ާާ��ѧ����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,7,'���̽�������','���̽�������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,8,'Flow switch setting','Flow switch setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1836,9,'���̽��Q�O��','���̽��Q�O��') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43066,'���̽�������','WFEC:SETTING',1836) 
GO

delete from SystemRightToGroup where rightid =1836
GO
INSERT INTO SystemRightToGroup ( groupid, rightid ) VALUES  ( 8,1836)
GO