delete from SystemRightDetail where rightid = 876
/
delete from SystemRightsLanguage where id = 876
/
delete from SystemRights where id = 876
/

insert into SystemRights (id,rightdesc,righttype) values (876,'手机版本设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,7,'手机版本设置','手机版本设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,8,'Ecology Mobile Setting','Ecology Mobile Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (876,9,'手機版本設置','手機版本設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4398,'手机版本设置','Mobile:Setting',876) 
/

