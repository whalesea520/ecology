delete from HtmlLabelIndex where id=21511 
GO
delete from HtmlLabelInfo where indexid=21511 
GO
INSERT INTO HtmlLabelIndex values(21511,'主题词描述') 
GO
delete from HtmlLabelIndex where id=21512 
GO
delete from HtmlLabelInfo where indexid=21512 
GO
INSERT INTO HtmlLabelIndex values(21512,'是否主题词') 
GO
delete from HtmlLabelIndex where id=21510 
GO
delete from HtmlLabelInfo where indexid=21510 
GO
INSERT INTO HtmlLabelIndex values(21510,'主题词名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(21510,'主题词名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21510,'Keyword Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21511,'主题词描述',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21511,'Keyword Description',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21512,'是否主题词',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21512,'Is Keyword Or Not',8) 
GO

delete from HtmlLabelIndex where id=21515 
GO
delete from HtmlLabelInfo where indexid=21515 
GO
INSERT INTO HtmlLabelIndex values(21515,'同一节点下的主题词不能重复！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21515,'同一节点下的主题词不能重复！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21515,'The keywords under a same node can''t be repeated!',8) 
GO

delete from HtmlLabelIndex where id=21516 
GO
delete from HtmlLabelInfo where indexid=21516 
GO
INSERT INTO HtmlLabelIndex values(21516,'主题词字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(21516,'主题词字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21516,'Keyword Field',8) 
GO

delete from HtmlLabelIndex where id=21517 
GO
delete from HtmlLabelInfo where indexid=21517 
GO
INSERT INTO HtmlLabelIndex values(21517,'浏览主题词') 
GO
INSERT INTO HtmlLabelInfo VALUES(21517,'浏览主题词',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21517,'View Keyword',8) 
GO
