delete from SystemRightDetail where rightid =1910
/
delete from SystemRightsLanguage where id =1910
/
delete from SystemRights where id =1910
/
insert into SystemRights (id,rightdesc,righttype) values (1910,'��Ա��Ϣ����','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,7,'��Ա��Ϣ����','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,9,'�ˆT��Ϣ����','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,8,'Personnel information export','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43137,'��Ա��Ϣ����Ȩ��','HrmResourceInfo:Import',1910) 
/