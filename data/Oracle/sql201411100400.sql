delete from SystemRightDetail where rightid =1771
/
delete from SystemRightsLanguage where id =1771
/
delete from SystemRights where id =1771
/
insert into SystemRights (id,rightdesc,righttype) values (1771,'������֤����Ա','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,7,'������֤����Ա','������֤����Ա') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,8,'code administrator','code administrator') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1771,9,'������֤����Ա','������֤����Ա') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43006,'������֤����Ա','code:Administrator',1771) 
/