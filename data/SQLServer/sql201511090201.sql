delete from HtmlLabelIndex where id=126043 
GO
delete from HtmlLabelInfo where indexid=126043 
GO
INSERT INTO HtmlLabelIndex values(126043,'存在链接字段，不能设置主键') 
GO
INSERT INTO HtmlLabelInfo VALUES(126043,'存在链接字段，不能设置主键',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126043,'The link field exists,you can not set the primary key',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126043,'存在鏈接字段，不能設置主鍵',9) 
GO	
delete from HtmlLabelIndex where id=126042 
GO
delete from HtmlLabelInfo where indexid=126042 
GO
INSERT INTO HtmlLabelIndex values(126042,'主键字段已存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(126042,'主键字段已存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126042,'The primary key field already exists',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126042,'主鍵字段已經存在',9) 
GO