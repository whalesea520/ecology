delete from SystemRightDetail where rightid =1889
/
delete from SystemRightsLanguage where id =1889
/
delete from SystemRights where id =1889
/
insert into SystemRights (id,rightdesc,righttype) values (1889,'归档集成','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,9,'歸檔集成','歸檔集成') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,7,'归档集成','归档集成') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,8,'exp','exp') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43118,'归档集成设置','exp:expsetting',1889) 
/