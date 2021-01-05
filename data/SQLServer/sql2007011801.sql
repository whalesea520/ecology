delete from HtmlLabelIndex where id between 20000 and 20010
go
delete from HtmlLabelInfo where indexid between 20000 and 20010
go

INSERT INTO HtmlLabelIndex values(20000,'必须大于已用空间大小') 
GO
INSERT INTO HtmlLabelInfo VALUES(20000,'必须大于已用空间大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20000,'greater than used album size',8) 
GO
INSERT INTO HtmlLabelIndex values(20001,'上传图片') 
GO
INSERT INTO HtmlLabelIndex values(20005,'已用空间') 
GO
INSERT INTO HtmlLabelIndex values(20006,'剩余空间') 
GO
INSERT INTO HtmlLabelIndex values(20008,'请输入图片标题') 
GO
INSERT INTO HtmlLabelIndex values(20003,'相册') 
GO
INSERT INTO HtmlLabelIndex values(20004,'空间大小') 
GO
INSERT INTO HtmlLabelIndex values(20002,'新建目录') 
GO
INSERT INTO HtmlLabelIndex values(20007,'使用情况') 
GO
INSERT INTO HtmlLabelInfo VALUES(20001,'上传图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20001,'Upload',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20002,'新建目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20002,'Add Folder',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20003,'相册',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20003,'Album',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20004,'空间大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20004,'Album Size',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20005,'已用空间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20005,'Used Size',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20006,'剩余空间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20006,'Free Size',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20007,'使用情况',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20007,'Status',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20008,'请输入图片标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20008,'Please input the photo title',8) 
GO
INSERT INTO HtmlLabelIndex values(20009,'发表评论') 
GO
INSERT INTO HtmlLabelIndex values(20010,'正在载入评论, 请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(20009,'发表评论',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20009,'Post Comment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20010,'正在载入评论, 请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20010,'Loading comments, please wait...',8) 
GO

delete from HtmlLabelIndex where id in (20162,20163,20164)
go
delete from HtmlLabelInfo where indexid in (20162,20163,20164)
go

INSERT INTO HtmlLabelIndex values(20162,'我的相册') 
GO
INSERT INTO HtmlLabelIndex values(20163,'相册主页') 
GO
INSERT INTO HtmlLabelIndex values(20164,'相册查询') 
GO
INSERT INTO HtmlLabelInfo VALUES(20162,'我的相册',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20162,'Album',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20163,'相册主页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20163,'Home',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20164,'相册查询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20164,'Search',8) 
GO

insert into SystemRights (id,rightdesc,righttype,detachable) values (690,'相册维护权限','1',1) 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (690,7,'相册维护权限','相册维护权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (690,8,'Album Manage','Album Manage') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4198,'相册维护','Album:Maint',690) 
GO
