delete from SystemRightDetail where rightid = 843
GO
delete from SystemRightsLanguage where id = 843
GO
delete from SystemRights where id = 843
GO
insert into SystemRights (id,rightdesc,righttype) values (843,'收发文维护','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,7,'收发文维护','收发文维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,8,'Send or Reveive Doc Editor','Send or Reveive Doc Editor') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,9,'收发文维护','收发文维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4358,'收发文维护','SRDoc:Edit',843) 
GO
