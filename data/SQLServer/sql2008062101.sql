delete from HtmlLabelIndex where id=21575 
GO
delete from HtmlLabelInfo where indexid=21575 
GO
INSERT INTO HtmlLabelIndex values(21575,'客户卡片联系人不能为空，不能删除该联系人') 
GO
INSERT INTO HtmlLabelInfo VALUES(21575,'客户卡片联系人不能为空，不能删除该联系人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21575,'CustomerContact Cannot be empty，Cannot be delete',8) 
GO
