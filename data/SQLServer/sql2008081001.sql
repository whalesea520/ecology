delete from HtmlLabelIndex where id=21748 
GO
delete from HtmlLabelInfo where indexid=21748 
GO
INSERT INTO HtmlLabelIndex values(21748,'表单已使用，已有字段不能删除！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21748,'表单已使用，已有字段不能删除！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21748,'as the form has been used,the fields of the form cann''t be deleted!',8) 
GO

delete from HtmlLabelIndex where id=21778 
GO
delete from HtmlLabelInfo where indexid=21778 
GO
INSERT INTO HtmlLabelIndex values(21778,'主表') 
GO
INSERT INTO HtmlLabelInfo VALUES(21778,'主表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21778,'maintable',8) 
GO

delete from HtmlLabelIndex where id=21810 
GO
delete from HtmlLabelInfo where indexid=21810 
GO
INSERT INTO HtmlLabelIndex values(21810,'是系统字段，不能使用！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21810,'是系统字段，不能使用！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21810,'is the system field,can not use it',8) 
GO
