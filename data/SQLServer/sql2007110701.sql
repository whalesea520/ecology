delete from HtmlLabelIndex where id=21089 
GO
delete from HtmlLabelInfo where indexid=21089 
GO
INSERT INTO HtmlLabelIndex values(21089,'该类型已经被引用,不能进行删除！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21089,'该类型已经被引用,不能进行删除！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21089,'this type is already referenced ,Donot delete!',8) 
GO