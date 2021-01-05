Delete HtmlLabelIndex where id=20858
GO
Delete HtmlLabelInfo where indexid=20858
GO
INSERT INTO HtmlLabelIndex values(20858,'标题中不能包括特殊字符''%''') 
GO
INSERT INTO HtmlLabelInfo VALUES(20858,'标题中不能包括特殊字符''%''',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20858,'Title can not contain ''%''',8) 
GO