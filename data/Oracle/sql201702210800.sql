delete from SystemRightDetail where rightid =2057
/
delete from SystemRightsLanguage where id =2057
/
delete from SystemRights where id =2057
/
insert into SystemRights (id,rightdesc,righttype) values (2057,'�ͻ�Ӧ������ά��','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,7,'�ͻ�Ӧ������','�ͻ�Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,9,'�͑������O��','�͑������O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,8,'customer application settings','customer application settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2057,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43275,'�ͻ�-Ӧ������ά��Ȩ��','Customer:Settings',2057)
/