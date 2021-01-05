delete from SystemRights where id =1505
/
delete from SystemRightDetail where rightid =1505
/
delete from SystemRightsLanguage where id =1505
/
insert into SystemRights (id,rightdesc,righttype) values (1505,'绩效考核基础设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,8,'GP Base Setting','GP Base Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,7,'绩效考核基础设置','绩效考核基础设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,9,'績效考核基礎設置','績效考核基礎設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42750,'绩效考核基础设置','GP_BaseSettingMaint',1505) 
/
