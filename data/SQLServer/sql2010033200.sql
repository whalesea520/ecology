delete from SystemRights where id=805 
GO
delete from SystemRightsLanguage where id=805 
GO
delete from SystemRightDetail where id=4316 
GO
insert into SystemRights (id,rightdesc,righttype) values (805,'��ʱͨѶ','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,8,'Instant messaging','Instant messaging') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,7,'��ʱͨѶ','��ʱͨѶ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (805,9,'��ʱͨѶ','��ʱͨѶ') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4316,'��ʱͨѶ','Messages:All',805) 
GO