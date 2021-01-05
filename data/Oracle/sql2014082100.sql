delete from SystemRightDetail where rightid =1678
/
delete from SystemRightsLanguage where id =1678
/
delete from SystemRights where id =1678
/
insert into SystemRights (id,rightdesc,righttype) values (1678,'项目应用设置','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,7,'项目应用设置','项目应用设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,9,'項目應用設置','項目應用設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,8,'Project APP Settings','Project APP Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21678,'项目应用设置','Prj:AppSettings',1678) 
/





























