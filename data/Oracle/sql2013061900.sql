delete from SystemRightDetail where rightid =1508
/
delete from SystemRightsLanguage where id =1508
/
delete from SystemRights where id =1508
/
insert into SystemRights (id,rightdesc,righttype) values (1508,'֤�չ�����̨ά��','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,8,'License management background maintenance','License management background maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,7,'֤�չ�����̨ά��','֤�չ�����̨ά��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1508,9,'�C�չ�����̨�S�o','�C�չ�����̨�S�o') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42753,'License:manager','֤�չ�����̨ά��',1508) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42754,'֤�չ�����̨ά��','License:manager',1508) 
/