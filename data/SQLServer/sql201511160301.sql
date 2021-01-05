alter table mode_pageexpand add tabshowtype int
GO
delete from HtmlLabelIndex where id=126080 
GO
delete from HtmlLabelInfo where indexid=126080 
GO
INSERT INTO HtmlLabelIndex values(126080,'ÄÚÇ¶') 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'ÄÚÇ¶',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'inline',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126080,'ÄÚÇ¶',9) 
GO
