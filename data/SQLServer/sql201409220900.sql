delete from SystemRightDetail where rightid =1736
GO
delete from SystemRightsLanguage where id =1736
GO
delete from SystemRights where id =1736
GO
insert into SystemRights (id,rightdesc,righttype) values (1736,'Ȩ�޸���ά��','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,7,'Ȩ�޸���ά��','Ȩ�޸���ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,8,'HrmRrightCopy','HrmRrightCopy') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1736,9,'�����}�u�S�o','�����}�u�S�o') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42967,'Ȩ�޸���','HrmRrightCopy:copy',1736) 
GO