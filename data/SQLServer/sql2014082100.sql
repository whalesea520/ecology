delete from SystemRightDetail where rightid =1678
GO
delete from SystemRightsLanguage where id =1678
GO
delete from SystemRights where id =1678
GO
insert into SystemRights (id,rightdesc,righttype) values (1678,'��ĿӦ������','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,7,'��ĿӦ������','��ĿӦ������') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,9,'�Ŀ�����O��','�Ŀ�����O��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1678,8,'Project APP Settings','Project APP Settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (21678,'��ĿӦ������','Prj:AppSettings',1678) 
GO




























