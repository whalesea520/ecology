delete from SystemRightDetail where rightid =1747
GO
delete from SystemRightsLanguage where id =1747
GO
delete from SystemRights where id =1747
GO
insert into SystemRights (id,rightdesc,righttype) values (1747,'Ȩ��ɾ��ά��','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,9,'���ބh���S�o','���ބh���S�o') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,7,'Ȩ��ɾ��ά��','Ȩ��ɾ��ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1747,8,'HrmRrightDelete','HrmRrightDelete') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42978,'Ȩ��ɾ��','HrmRrightDelete:delete',1747) 
GO