delete from SystemRightDetail where rightid =1292
/
delete from SystemRightsLanguage where id =1292
/
delete from SystemRights where id =1292
/
insert into SystemRights (id,rightdesc,righttype) values (1292,'离职人员查看','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,7,'离职人员查看','离职人员查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,9,'離職人員查看','離職人員查看') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1292,8,'Departure View','Departure View') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42569,'离职人员查看','hrm:departureView',1292) 
/