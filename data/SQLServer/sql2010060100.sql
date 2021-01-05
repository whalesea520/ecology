delete from SystemRightDetail where rightid = 935
GO
delete from SystemRightsLanguage where id = 935
GO
delete from SystemRights where id = 935
GO

insert into SystemRights (id,rightdesc,righttype) values (935,'文档置顶权限','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (935,7,'文档置顶权限','文档置顶权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (935,8,'Document Top Permissions','Document Top Permissions') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (935,9,'文檔置頂權限','文檔置頂權限') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4462,'文档置顶权限','Document:Top',935) 
GO
