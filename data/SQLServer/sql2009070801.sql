delete from HtmlLabelIndex where id=23303 
GO
delete from HtmlLabelInfo where indexid=23303 
GO
INSERT INTO HtmlLabelIndex values(23303,'客户名称重名,是否继续操作?') 
GO
INSERT INTO HtmlLabelInfo VALUES(23303,'客户名称重名,是否继续操作?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23303,'Customer name already exists, whether or not to continue to operate?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23303,'客戶名稱重名,是否繼續操作?',9) 
GO