delete from SystemRightDetail where rightid =1979
/
delete from SystemRightsLanguage where id =1979
/
delete from SystemRights where id =1979
/
insert into SystemRights (id,rightdesc,righttype) values (1979,'Ԥ�����Ȩ��','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,7,'Ԥ�����Ȩ��','Ԥ�����Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,9,'�A�㾎�ƙ���','�A�㾎�ƙ���') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,8,'Budget authority','Budget authority') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1979,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43197,'Ԥ�����Ȩ��','BudgetAuthorityRule:edit',1979) 
/


delete from systemrighttogroup where RIGHTid = 1979
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 1979)
/





delete from SystemRightDetail where rightid =1980
/
delete from SystemRightsLanguage where id =1980
/
delete from SystemRights where id =1980
/
insert into SystemRights (id,rightdesc,righttype) values (1980,'Ԥ�����ֻ��Ȩ��','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,7,'Ԥ�����ֻ��Ȩ��','Ԥ�����ֻ��Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,9,'�A�㾎���b�x����','�A�㾎���b�x����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,8,'Budget for read-only access','Budget for read-only access') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1980,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43198,'Ԥ�����ֻ��Ȩ��','BudgetAuthorityRule:readOnly',1980) 
/


delete from systemrighttogroup where RIGHTid = 1980
/
insert into systemrighttogroup (GROUPid, RIGHTid) values (4, 1980)
/