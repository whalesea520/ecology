delete from SystemRightDetail where rightid =2035
/
delete from SystemRightsLanguage where id =2035
/
delete from SystemRights where id =2035
/
insert into SystemRights (id,rightdesc,righttype) values (2035,'流程回收站','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,8,'Process Recycle Bin','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,7,'流程回收站','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,9,'流程回收站','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2035,15,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43253,'流程回收站','WorkflowRecycleBin:All',2035) 
/