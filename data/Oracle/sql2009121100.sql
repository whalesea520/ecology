delete from SystemRightDetail where rightid = 902
/
delete from SystemRightsLanguage where id = 902
/
delete from SystemRights where id = 902
/

insert into SystemRights (id,rightdesc,righttype) values (902,'群组设置','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (902,7,'群组设置','群组设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (902,8,'Groups Set','Groups Set') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (902,9,'群組設置','群組設置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4428,'群组设置','GroupsSet:Maintenance',902) 
/
