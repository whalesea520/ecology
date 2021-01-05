
delete from SystemRightDetail where rightid =1560
/
delete from SystemRightsLanguage where id =1560
/
delete from SystemRights where id =1560
/
insert into SystemRights (id,rightdesc,righttype) values (1560,'甘特图设置','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,9,'甘特圖設置','甘特圖設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,8,'Gantt Setting','Gantt Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1560,7,'甘特图设置','甘特图设置') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (50001,'甘特图设置权限','Pm:GanttSetting',1560) 
/
insert into SystemRightToGroup (groupid,rightid) values (5,1560) 
/


