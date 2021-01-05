delete from SystemRightDetail where rightid =90
/
delete from SystemRightsLanguage where id =90
/
delete from SystemRights where id =90
/
insert into SystemRights (id,rightdesc,righttype) values (90,'系统设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,8,'SystemSet','SystemSet') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (90,7,'系统设置','系统设置') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (330,'系统设置','SystemSetEdit:Edit',90) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43370,'敏感字维护权限','SensitiveWord:Manage',90) 
/