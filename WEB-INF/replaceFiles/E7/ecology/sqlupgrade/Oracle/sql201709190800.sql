delete from SystemRightDetail where rightid =90
/
delete from SystemRightsLanguage where id =90
/
delete from SystemRights where id =90
/
insert into SystemRights (id,rightdesc,righttype) values (90,'ϵͳ����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,8,'SystemSet','SystemSet') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,7,'ϵͳ����','ϵͳ����') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (330,'ϵͳ����','SystemSetEdit:Edit',90) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43370,'������ά��Ȩ��','SensitiveWord:Manage',90) 
/