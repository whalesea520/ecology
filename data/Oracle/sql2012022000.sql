delete from SystemRightDetail where rightid =1184
/
delete from SystemRightsLanguage where id =1184
/
delete from SystemRights where id =1184
/
insert into SystemRights (id,rightdesc,righttype) values (1184,'图表元素使用权限','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1184,7,'图表元素使用权限','图表元素使用权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1184,9,'圖表元素使用許可權','圖表元素使用許可權') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1184,8,'ReportFormRight','ReportFormRight') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42400,'图表元素使用权限','ReportFormElement',1184) 
/
