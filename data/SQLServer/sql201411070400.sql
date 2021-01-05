delete from SystemRightDetail where rightid =1769
GO
delete from SystemRightsLanguage where id =1769
GO
delete from SystemRights where id =1769
GO
insert into SystemRights (id,rightdesc,righttype) values (1769,'权限查询','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,9,'權限查詢','權限查詢') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,8,'Query permissions','Query permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1769,7,'权限查询','权限查询') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43004,'权限查询','HrmRrightAuthority:search',1769) 
GO