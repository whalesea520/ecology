delete from SystemRightDetail where rightid =1749
GO
delete from SystemRightsLanguage where id =1749
GO
delete from SystemRights where id =1749
GO
insert into SystemRights (id,rightdesc,righttype) values (1749,'���̷���ά��','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,9,'���̷���S�o','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,7,'���̷���ά��','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1749,8,'workflow Reverse maintenance','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42979,'���̷���ά��','Workflow:permission',1749) 
GO