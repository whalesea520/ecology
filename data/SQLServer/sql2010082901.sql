delete from HtmlLabelIndex where id=25019 
GO
delete from HtmlLabelInfo where indexid=25019 
GO
INSERT INTO HtmlLabelIndex values(25019,'目录已存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(25019,'目录已存在！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25019,'Directory already exists!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25019,'目錄已存在！',9) 
GO

delete from HtmlLabelIndex where id=25021 
GO
delete from HtmlLabelInfo where indexid=25021 
GO
INSERT INTO HtmlLabelIndex values(25021,'文件已存在！') 
GO
INSERT INTO HtmlLabelInfo VALUES(25021,'文件已存在！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25021,'File already exists!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25021,'文件已存在！',9) 
GO
