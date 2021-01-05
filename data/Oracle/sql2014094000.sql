delete from SystemRightDetail where rightid =1731
/
delete from SystemRightsLanguage where id =1731
/
delete from SystemRights where id =1731
/
insert into SystemRights (id,rightdesc,righttype) values (1731,'矩阵管理权限','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,8,'Matrix management authority','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,7,'矩阵管理权限','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1731,9,'矩陣管理權限','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42965,'矩阵维护权限','Matrix:Maint',1731) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42960,'矩阵批量维护权限','Matrix:MassMaint',1731) 
/