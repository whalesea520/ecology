delete from HtmlLabelIndex where id=24000 
GO
delete from HtmlLabelInfo where indexid=24000 
GO
INSERT INTO HtmlLabelIndex values(24000,'单附件直接打开') 
GO
INSERT INTO HtmlLabelInfo VALUES(24000,'单附件直接打开',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24000,'auto open while single attachment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24000,'单附件直接打开',9) 
GO
