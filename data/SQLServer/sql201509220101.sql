delete from HtmlLabelIndex where id=125644 
GO
delete from HtmlLabelInfo where indexid=125644 
GO
INSERT INTO HtmlLabelIndex values(125644,'表单已引用，不能删除！') 
GO
INSERT INTO HtmlLabelInfo VALUES(125644,'表单已引用，不能删除！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125644,'can not delete as form is used!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125644,'表單已引用，不能删除！',9) 
GO