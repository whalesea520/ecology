delete from HtmlLabelIndex where id=127144 
GO
delete from HtmlLabelInfo where indexid=127144 
GO
INSERT INTO HtmlLabelIndex values(127144,'是否需要生成制度树') 
GO
INSERT INTO HtmlLabelInfo VALUES(127144,'是否需要生成制度树',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127144,'is need create institution tree',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127144,'是否需要生成制度樹',9) 
GO

delete from HtmlLabelIndex where id=127145 
GO
delete from HtmlLabelInfo where indexid=127145 
GO
INSERT INTO HtmlLabelIndex values(127145,'上级文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(127145,'上级文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127145,'superior document',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127145,'上級文檔',9) 
GO

delete from HtmlLabelIndex where id=127146 
GO
delete from HtmlLabelInfo where indexid=127146 
GO
INSERT INTO HtmlLabelIndex values(127146,'下级文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(127146,'下级文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127146,'subordinate document',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127146,'下級文檔',9) 
GO