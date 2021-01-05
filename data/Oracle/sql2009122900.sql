delete from SystemRightDetail where rightid = 873
/
delete from SystemRightsLanguage where id = 873
/
delete from SystemRights where id = 873
/

insert into SystemRights (id,rightdesc,righttype) values (873,'文档日志查看','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,7,'文档日志查看','文档日志查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,8,'File log view','File log view') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (873,9,'文?日?查看','文?日?查看') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4395,'文档日志查看权限','FileLogView:View',873) 
/
