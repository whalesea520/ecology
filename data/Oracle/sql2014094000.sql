delete from SystemRightDetail where rightid =1731
/
delete from SystemRightsLanguage where id =1731
/
delete from SystemRights where id =1731
/
insert into SystemRights (id,rightdesc,righttype) values (1731,'�������Ȩ��','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,8,'Matrix management authority','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,7,'�������Ȩ��','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,9,'��ꇹ������','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42965,'����ά��Ȩ��','Matrix:Maint',1731) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42960,'��������ά��Ȩ��','Matrix:MassMaint',1731) 
/