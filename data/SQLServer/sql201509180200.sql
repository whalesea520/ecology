delete from SystemRightDetail where rightid =1907
GO
delete from SystemRightsLanguage where id =1907
GO
delete from SystemRights where id =1907
GO
insert into SystemRights (id,rightdesc,righttype) values (1907,'�ƶ�ǩ���������','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,8,'Mobile sign information management','Mobile sign information management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,7,'�ƶ�ǩ���������','�ƶ�ǩ���������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,9,'�ƄӺ�����r����','�ƄӺ�����r����') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43134,'�ƶ�ǩ���������','MobileSignInfo:Manage',1907) 
GO