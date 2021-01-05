delete from SystemRightDetail where rightid =1141
/
delete from SystemRightsLanguage where id =1141
/
delete from SystemRights where id =1141
/
insert into SystemRights (id,rightdesc,righttype) values (1141,'Œ¢≤©…Ë÷√','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1141,7,'Œ¢≤©…Ë÷√','Œ¢≤©…Ë÷√') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1141,9,'Œ¢≤©‘O÷√','Œ¢≤©‘O÷√') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1141,8,'Blog Setting','Blog Setting') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42352,'Œ¢≤©ª˘±æ…Ë÷√','blog:baseSetting',1141) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42353,'Œ¢≤©”¶”√…Ë÷√','blog:appSetting',1141) 
/
