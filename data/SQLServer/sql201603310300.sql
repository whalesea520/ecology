delete from SystemRightDetail where rightid =1974
GO
delete from SystemRightsLanguage where id =1974
GO
delete from SystemRights where id =1974
GO
insert into SystemRights (id,rightdesc,righttype) values (1974,'ͳһ������̨ά��','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'ͳһ������̨ά��','ͳһ������̨ά��') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'Unified agency background maintenance','Unified agency background maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'�yҼ���k�����_�S�o','�yҼ���k�����_�S�o') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'ͳһ������̨ά��','ofs:ofssetting',1974) 
GO