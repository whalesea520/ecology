delete from SystemRightDetail where rightid =1971
GO
delete from SystemRightsLanguage where id =1971
GO
delete from SystemRights where id =1971
GO
insert into SystemRights (id,rightdesc,righttype) values (1971,'messager��̨����','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,7,'Messager����','Messager����') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,8,'Messager Manager','Messager manager') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1971,9,'Messager����','Messager����') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43191,'Messager����','message:manager',1971) 
GO