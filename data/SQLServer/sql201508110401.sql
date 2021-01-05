delete from HtmlLabelIndex where id=125293 
GO
delete from HtmlLabelInfo where indexid=125293 
GO
INSERT INTO HtmlLabelIndex values(125293,'确定删除此客户') 
GO
INSERT INTO HtmlLabelInfo VALUES(125293,'确定删除此客户？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125293,'Sure to delete this customer?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125293,'确定删除此客戶？',9) 
GO