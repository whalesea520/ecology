delete from SystemRightDetail where rightid =90
GO
delete from SystemRightsLanguage where id =90
GO
delete from SystemRights where id =90
GO
insert into SystemRights (id,rightdesc,righttype) values (90,'ϵͳ����','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,8,'SystemSet','SystemSet') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,7,'ϵͳ����','ϵͳ����') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (330,'ϵͳ����','SystemSetEdit:Edit',90) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43370,'������ά��Ȩ��','SensitiveWord:Manage',90) 
GO