delete from SystemRightDetail where rightid =1971
/
delete from SystemRightsLanguage where id =1971
/
delete from SystemRights where id =1971
/
insert into SystemRights (id,rightdesc,righttype) values (1971,'messager��̨����','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,7,'Messager����','Messager����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,8,'Messager Manager','Messager manager') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,9,'Messager����','Messager����') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43191,'Messager����','message:manager',1971) 
/