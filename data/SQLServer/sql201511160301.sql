alter table mode_pageexpand add tabshowtype int
GO
delete from HtmlLabelIndex where id=126080 
GO
delete from HtmlLabelInfo where indexid=126080 
GO
INSERT INTO HtmlLabelIndex values(126080,'��Ƕ') 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'��Ƕ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'inline',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'��Ƕ',9) 
GO