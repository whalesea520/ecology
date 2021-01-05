delete from SystemRightDetail where rightid =1769
/
delete from SystemRightsLanguage where id =1769
/
delete from SystemRights where id =1769
/
insert into SystemRights (id,rightdesc,righttype) values (1769,'权限查询','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,9,'權限查詢','權限查詢') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,8,'Query permissions','Query permissions') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,7,'权限查询','权限查询') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43004,'权限查询','HrmRrightAuthority:search',1769) 
/