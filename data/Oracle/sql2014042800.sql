delete from SystemRightDetail where rightid =1590
/
delete from SystemRightsLanguage where id =1590
/
delete from SystemRights where id =1590
/
insert into SystemRights (id,rightdesc,righttype) values (1590,'����Ӧ������','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,8,'meeting manager','meeting manager') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,7,'����Ӧ������','����Ӧ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1590,9,'���h�����O��','���h�����O��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42829,'����Ӧ������','meetingmanager:all',1590) 
/