delete from SystemRights where id=805 
/
delete from SystemRightsLanguage where id=805 
/
delete from SystemRightDetail where id=4316 
/
insert into SystemRights (id,rightdesc,righttype) values (805,'��ʱͨѶ','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,8,'Instant messaging','Instant messaging') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,7,'��ʱͨѶ','��ʱͨѶ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,9,'��ʱͨѶ','��ʱͨѶ') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4316,'��ʱͨѶ','Messages:All',805) 
/