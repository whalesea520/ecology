delete from SystemRightDetail where rightid =806
GO
delete from SystemRightsLanguage where id =806
GO
delete from SystemRights where id =806
GO
delete from SystemRightDetail where rightid =1827
GO
delete from SystemRightsLanguage where id =1827
GO
delete from SystemRights where id =1827
GO
insert into SystemRights (id,rightdesc,righttype) values (1827,'ϵͳ��Ϣ����ά��','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,7,'ϵͳ��Ϣ����ά��','ϵͳ��Ϣ����ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,10,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,8,'HrmResourceSys','HrmResourceSys') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1827,9,'ϵ�y��Ϣ�����S�o','ϵ�y��Ϣ�����S�o') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43059,'ϵͳ��Ϣ����ά��','HrmResourceSys:Mgr',1827) 
GO