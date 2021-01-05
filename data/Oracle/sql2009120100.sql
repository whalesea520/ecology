delete from SystemRightDetail where rightid = 843
/
delete from SystemRightsLanguage where id = 843
/
delete from SystemRights where id = 843
/
insert into SystemRights (id,rightdesc,righttype) values (843,'收发文维护','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,7,'收发文维护','收发文维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,8,'Send or Reveive Doc Editor','Send or Reveive Doc Editor') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (843,9,'收发文维护','收发文维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4358,'收发文维护','SRDoc:Edit',843) 
/
