delete from SystemRightDetail where rightid =1974
GO
delete from SystemRightsLanguage where id =1974
GO
delete from SystemRights where id =1974
GO
insert into SystemRights (id,rightdesc,righttype) values (1974,'统一代办库后台维护','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'统一代办库后台维护','统一代办库后台维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'Unified agency background maintenance','Unified agency background maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'統壹代辦庫後臺維護','統壹代辦庫後臺維護') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'统一代办库后台维护','ofs:ofssetting',1974) 
GO