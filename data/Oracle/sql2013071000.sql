delete from SystemRightDetail where rightid =1514
/
delete from SystemRightsLanguage where id =1514
/
delete from SystemRights where id =1514
/
insert into SystemRights (id,rightdesc,righttype) values (1514,'��Ŀ��������Ȩ��','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,7,'��Ŀ��������Ȩ��','��Ŀ��������Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,8,'ProjectAccessoryConfiguration','ProjectAccessoryConfiguration') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1514,9,'��Ŀ��������Ȩ��','��Ŀ��������Ȩ��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4081,'��Ŀ��������Ȩ��','Project maintenance',1514) 
/
insert into SystemRightToGroup (groupid,rightid) values (7,1514)
/