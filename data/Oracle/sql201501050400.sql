delete from SystemRightDetail where rightid =1803
/
delete from SystemRightsLanguage where id =1803
/
delete from SystemRights where id =1803
/
insert into SystemRights (id,rightdesc,righttype) values (1803,'��Ŀ����Ȩ��','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,9,'�Ŀ����','�Ŀ����') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,7,'��Ŀ����Ȩ��','��Ŀ����Ȩ��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,8,'Project Import','Project Import') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1803,10,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41803,'��Ŀ����Ȩ��','Prj:Imp',1803) 
/