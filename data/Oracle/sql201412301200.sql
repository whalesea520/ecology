delete from SystemRightDetail where rightid =1297
/
delete from SystemRightsLanguage where id =1297
/
delete from SystemRights where id =1297
/
insert into SystemRights (id,rightdesc,righttype) values (1297,'������ģģ�����','7')  
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,7,'������ģģ�����','������ģģ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,8,'modeling of the form module management','modeling of the form module management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1297,9,'��ν�ģģ�K����','��ν�ģģ�K����') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42573,'������ģģ�����','ModeSetting:All',1297) 
/
update SystemRights set detachable=1 where id =1297
/
delete from SystemRightDetail where rightid =1796
/
delete from SystemRightsLanguage where id =1796
/
delete from SystemRights where id =1796
/
insert into SystemRights (id,rightdesc,righttype) values (1796,'������ģӦ�ù���','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,8,'application form model management','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,7,'������ģӦ�ù���','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1796,9,'��ν�ģ���ù���','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43030,'������ģӦ�ù���','FORMMODEAPP:ALL',1796) 
/
update SystemRights set detachable=1 where id =1796
/
delete from SystemRightDetail where rightid =1797
/
delete from SystemRightsLanguage where id =1797
/
delete from SystemRights where id =1797
/
insert into SystemRights (id,rightdesc,righttype) values (1797,'������ģ��������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,8,'form modeling forms management','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,7,'������ģ��������','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1797,9,'��ν�ģ��ι���','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43031,'������ģ��������','FORMMODEFORM:ALL',1797) 
/
update SystemRights set detachable=1 where id =1797
/