delete from SystemRightDetail where rightid =1678
/
delete from SystemRightsLanguage where id =1678
/
delete from SystemRights where id =1678
/
insert into SystemRights (id,rightdesc,righttype) values (1678,'��ĿӦ������','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,7,'��ĿӦ������','��ĿӦ������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,9,'�Ŀ�����O��','�Ŀ�����O��') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,8,'Project APP Settings','Project APP Settings') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21678,'��ĿӦ������','Prj:AppSettings',1678) 
/




























