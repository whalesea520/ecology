delete from SystemRightDetail where rightid =2086
/
delete from SystemRightsLanguage where id =2086
/
delete from SystemRights where id =2086
/
insert into SystemRights (id,rightdesc,righttype,detachable) values (2086,'�ĵ�����վ����','1','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,14,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,9,'����վ�ęn����','����վ�ęn����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,7,'����վ�ĵ�����','����վ�ĵ�����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,8,'Recycle bin document management','Recycle bin document management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2086,15,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43308,'����վ�ĵ�����','DocumentRecycle:All',2086) 
/

delete from SystemRightToGroup where rightid=2086
/
insert into SystemRightToGroup(Groupid,Rightid) values (2,2086)
/