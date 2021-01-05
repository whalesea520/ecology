delete from SystemRightDetail where rightid =1535
GO
delete from SystemRightsLanguage where id =1535
GO
delete from SystemRights where id =1535
GO
insert into SystemRights (id,rightdesc,righttype) values (1535,'批量调整文档共享','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,8,'Document Sharing','Document Sharing') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,7,'批量调整文档共享','批量调整文档共享') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1535,9,'批量調整文檔共享','批量調整文檔共享') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42782,'批量调整文档共享','DocShareRight:all',1535) 
GO
