delete from SystemRightDetail where rightid =1923
/
delete from SystemRightsLanguage where id =1923
/
delete from SystemRights where id =1923
/
insert into SystemRights (id,rightdesc,righttype) values (1923,'�ʲ��۾�����','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,7,'�ʲ��۾�����','�ʲ��۾�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,9,'�Y�a���f�O��','�Y�a���f�O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,8,'Depreciation of assets','Depreciation of assets') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41923,'�ʲ��۾�����','Cpt4Mode:DeprecationSettings',1923) 
/