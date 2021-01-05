delete from HtmlLabelIndex where id=21635 
GO
delete from HtmlLabelInfo where indexid=21635 
GO
INSERT INTO HtmlLabelIndex values(21635,'如选，创建文档字段只显示新建，不显示选择和清除') 
GO
delete from HtmlLabelIndex where id=21634 
GO
delete from HtmlLabelInfo where indexid=21634 
GO
INSERT INTO HtmlLabelIndex values(21634,'是否只能新建正文') 
GO
INSERT INTO HtmlLabelInfo VALUES(21634,'是否只能新建正文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21634,'The only new body',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21635,'如选，创建文档字段只显示新建，不显示选择和清除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21635,'If elected, to create new documents show only field, do not show selection and removal',8) 
GO
