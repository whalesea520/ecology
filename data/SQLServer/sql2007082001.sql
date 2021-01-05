delete from HtmlLabelIndex where id in(15126,365,11,91,18214)
GO
delete from HtmlLabelInfo where indexid in(15126,365,119,91,18214)
GO

INSERT INTO HtmlLabelIndex values(15126,'搜索的结果太多无法显示! 请提供更精确的关键字搜索') 
GO
INSERT INTO HtmlLabelInfo VALUES(15126,'搜索的结果太多无法显示! 请提供更精确的关键字搜索',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(15126,'Result is too much to list,Pls search again by more precise Keyword',8) 
GO

INSERT INTO HtmlLabelIndex values(365,'新建') 
GO
INSERT INTO HtmlLabelInfo VALUES(365,'新建',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(365,'New',8) 
GO

INSERT INTO HtmlLabelIndex values(119,'共享') 
GO
INSERT INTO HtmlLabelInfo VALUES(119,'Share',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(119,'共享',7) 
GO
 
INSERT INTO HtmlLabelIndex values(91,'删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(91,'Delete',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(91,'删除',7) 
GO

INSERT INTO HtmlLabelIndex values(18214,'请选择') 
GO
INSERT INTO HtmlLabelInfo VALUES(18214,'请选择',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18214,'PlEASE CHOOSE',8) 
GO