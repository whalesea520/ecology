delete from HtmlLabelIndex where id=19789
GO
delete from HtmlLabelInfo where indexid=19789
GO

INSERT INTO HtmlLabelIndex values(19789,'新闻类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(19789,'新闻类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19789,'News Format',8) 
GO