delete from SystemRightDetail where rightid =1508
GO
delete from SystemRightsLanguage where id =1508
GO
delete from SystemRights where id =1508
GO
insert into SystemRights (id,rightdesc,righttype) values (1508,'֤�չ�����̨ά��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,8,'License management background maintenance','License management background maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,7,'֤�չ�����̨ά��','֤�չ�����̨ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,9,'�C�չ�����̨�S�o','�C�չ�����̨�S�o') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42753,'License:manager','֤�չ�����̨ά��',1508) 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42754,'֤�չ�����̨ά��','License:manager',1508) 
GO