delete from SystemRightDetail where rightid =1297
GO
delete from SystemRightsLanguage where id =1297
GO
delete from SystemRights where id =1297
GO
insert into SystemRights (id,rightdesc,righttype) values (1297,'������ģģ�����','7')  
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,7,'������ģģ�����','������ģģ�����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,8,'modeling of the form module management','modeling of the form module management') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,9,'��ν�ģģ�K����','��ν�ģģ�K����') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42573,'������ģģ�����','ModeSetting:All',1297) 
GO
update SystemRights set detachable=1 where id =1297
GO
delete from SystemRightDetail where rightid =1796
GO
delete from SystemRightsLanguage where id =1796
GO
delete from SystemRights where id =1796
GO
insert into SystemRights (id,rightdesc,righttype) values (1796,'������ģӦ�ù���','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,8,'application form model management','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,7,'������ģӦ�ù���','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,9,'��ν�ģ���ù���','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43030,'������ģӦ�ù���','FORMMODEAPP:ALL',1796) 
GO
update SystemRights set detachable=1 where id =1796
GO
delete from SystemRightDetail where rightid =1797
GO
delete from SystemRightsLanguage where id =1797
GO
delete from SystemRights where id =1797
GO
insert into SystemRights (id,rightdesc,righttype) values (1797,'������ģ��������','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,8,'form modeling forms management','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,7,'������ģ��������','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,9,'��ν�ģ��ι���','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43031,'������ģ��������','FORMMODEFORM:ALL',1797) 
GO
update SystemRights set detachable=1 where id =1797
GO