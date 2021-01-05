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
INSERT INTO HtmlLabelInfo VALUES(21778,'主錶',9) 
GO