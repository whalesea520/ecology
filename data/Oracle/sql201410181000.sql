delete from SystemRightDetail where rightid =1756
/
delete from SystemRightsLanguage where id =1756
/
delete from SystemRights where id =1756
/
insert into SystemRights (id,rightdesc,righttype) values (1756,'�ʼ�����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,8,'Email Setting','Email Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,7,'�ʼ�����','�ʼ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1756,9,'�]���O��','�]���O��') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42986,'�ʼ�ϵͳ����','email:sysSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42987,'�ʼ�ģ������','email:templateSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42988,'��ҵ��������','email:enterpriseSetting',1756) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42989,'����ռ�����','email:spaceSetting',1756) 
/