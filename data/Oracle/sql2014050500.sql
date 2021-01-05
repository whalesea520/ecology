
delete from SystemRightDetail where rightid =1643
/
delete from SystemRightsLanguage where id =1643
/
delete from SystemRights where id =1643
/
insert into SystemRights (id,rightdesc,righttype) values (1643,'短信应用设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,9,'短信應用設置','短信應用設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,7,'短信应用设置','短信应用设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1643,8,'Sms Setting','Sms Setting') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42875,'短信应用设置','Sms:Set',1643) 
/
