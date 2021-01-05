delete from SystemRightDetail where rightid =1910
/
delete from SystemRightsLanguage where id =1910
/
delete from SystemRights where id =1910
/
insert into SystemRights (id,rightdesc,righttype) values (1910,'人员信息导出','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,7,'人员信息导出','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,9,'人員信息導出','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,8,'Personnel information export','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1910,12,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43137,'人员信息导出权限','HrmResourceInfo:Import',1910) 
/