delete from HtmlLabelIndex where id=20411
GO
delete from HtmlLabelInfo where indexid=20411
GO
INSERT INTO HtmlLabelIndex values(20411,'此文档的最新版本正处于草稿/审批/待发布中，本操作无法处理！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20411,'此文档的最新版本正处于草稿/审批/待发布中，本操作无法处理！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20411,'The last doc is being drafted/to approve/to publish,so it can not be processed!',8)
GO