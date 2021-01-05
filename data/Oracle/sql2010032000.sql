delete from SystemRightDetail where rightid =916
/
delete from SystemRightsLanguage where id =916
/
delete from SystemRights where id =916
/
insert into SystemRights (id,rightdesc,righttype) values (916,'应用分权设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (916,7,'应用分权设置','应用分权设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (916,8,'应用分权设置','应用分权设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (916,9,'應用分權設置','應用分權設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4441,'应用分权设置','AppDetach:All',916) 
/
