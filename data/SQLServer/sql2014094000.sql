delete from SystemRightDetail where rightid =1731
GO
delete from SystemRightsLanguage where id =1731
GO
delete from SystemRights where id =1731
GO
insert into SystemRights (id,rightdesc,righttype) values (1731,'�������Ȩ��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,8,'Matrix management authority','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,7,'�������Ȩ��','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,9,'��ꇹ������','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42965,'����ά��Ȩ��','Matrix:Maint',1731) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42960,'��������ά��Ȩ��','Matrix:MassMaint',1731) 
GO