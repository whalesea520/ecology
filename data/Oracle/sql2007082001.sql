delete from HtmlLabelIndex where id in(15126,365,11,91,18214)
/
delete from HtmlLabelInfo where indexid in(15126,365,119,91,18214)
/

INSERT INTO HtmlLabelIndex values(15126,'搜索的结果太多无法显示! 请提供更精确的关键字搜索') 
/
INSERT INTO HtmlLabelInfo VALUES(15126,'搜索的结果太多无法显示! 请提供更精确的关键字搜索',7) 
/
INSERT INTO HtmlLabelInfo VALUES(15126,'Result is too much to list,Pls search again by more precise Keyword',8) 
/

INSERT INTO HtmlLabelIndex values(365,'新建') 
/
INSERT INTO HtmlLabelInfo VALUES(365,'新建',7) 
/
INSERT INTO HtmlLabelInfo VALUES(365,'New',8) 
/

INSERT INTO HtmlLabelIndex values(119,'共享') 
/
INSERT INTO HtmlLabelInfo VALUES(119,'Share',8) 
/
INSERT INTO HtmlLabelInfo VALUES(119,'共享',7) 
/
 
INSERT INTO HtmlLabelIndex values(91,'删除') 
/
INSERT INTO HtmlLabelInfo VALUES(91,'Delete',8) 
/
INSERT INTO HtmlLabelInfo VALUES(91,'删除',7) 
/

INSERT INTO HtmlLabelIndex values(18214,'请选择') 
/
INSERT INTO HtmlLabelInfo VALUES(18214,'请选择',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18214,'PlEASE CHOOSE',8) 
/