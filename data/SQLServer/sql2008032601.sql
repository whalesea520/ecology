delete from HtmlLabelIndex where id=21400 
GO
delete from HtmlLabelInfo where indexid=21400 
GO
INSERT INTO HtmlLabelIndex values(21400,'批量上传') 
GO
INSERT INTO HtmlLabelInfo VALUES(21400,'批量上传',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21400,'Docs Upload',8) 
GO


delete from HtmlLabelIndex where id=21406 
GO
delete from HtmlLabelInfo where indexid=21406 
GO
INSERT INTO HtmlLabelIndex values(21406,'选取多个文件') 
GO
delete from HtmlLabelIndex where id=21409 
GO
delete from HtmlLabelInfo where indexid=21409 
GO
INSERT INTO HtmlLabelIndex values(21409,'具有创建权限的目录') 
GO
delete from HtmlLabelIndex where id=21407 
GO
delete from HtmlLabelInfo where indexid=21407 
GO
INSERT INTO HtmlLabelIndex values(21407,'清除所有选择') 
GO
delete from HtmlLabelIndex where id=21408 
GO
delete from HtmlLabelInfo where indexid=21408 
GO
INSERT INTO HtmlLabelIndex values(21408,'选择新的目录后,页面属性将需要重新设置，是否需要继续?') 
GO
delete from HtmlLabelIndex where id=21405 
GO
delete from HtmlLabelInfo where indexid=21405 
GO
INSERT INTO HtmlLabelIndex values(21405,'文件上传列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(21405,'文件上传列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21405,'Doc Upload List',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21406,'选取多个文件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21406,'Select Multi Doc',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21407,'清除所有选择',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21407,'Clean all selected',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21408,'选择新的目录后,页面属性将需要重新设置，是否需要继续?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21408,'After selected new category,prop will be reset, Are you sure?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21409,'具有创建权限的目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21409,'Category with create',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (774,'批量上传权限','1') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (774,8,'MultiDocUpload','MultiDocUpload') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (774,7,'批量上传权限','批量上传权限') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4284,'批量上传权限','MultiDocUpload:maint',774) 
GO

insert into SystemRightToGroup (groupid, rightid) values (1,774)
GO
