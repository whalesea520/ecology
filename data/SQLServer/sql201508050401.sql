delete from HtmlLabelIndex where id=125152 
GO
delete from HtmlLabelInfo where indexid=125152 
GO
INSERT INTO HtmlLabelIndex values(125152,'主键字段内容不能包含中文') 
GO
INSERT INTO HtmlLabelInfo VALUES(125152,'主键字段内容不能包含中文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125152,'The content of the primary key field cannot contain in Chinese',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125152,'主键字段内容不能包含中文',9) 
GO