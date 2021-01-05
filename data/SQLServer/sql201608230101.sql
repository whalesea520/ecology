delete from HtmlLabelIndex where id=128381 
GO
delete from HtmlLabelInfo where indexid=128381 
GO
INSERT INTO HtmlLabelIndex values(128381,'自定义报表标题不能包含单引号或双引号') 
GO
INSERT INTO HtmlLabelInfo VALUES(128381,'自定义报表标题不能包含单引号或双引号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128381,'Custom report titles cannot contain single or double quotes',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128381,'自定義報表標題不能包含單引號或雙引號',9) 
GO