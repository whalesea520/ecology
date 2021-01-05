delete from HtmlLabelIndex where id=132214 
GO
delete from HtmlLabelInfo where indexid=132214 
GO
INSERT INTO HtmlLabelIndex values(132214,'其他参数中，参数名重复！') 
GO
INSERT INTO HtmlLabelInfo VALUES(132214,'其他参数中，参数名重复！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(132214,'In other parameters, the parameter''s name is repeated',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(132214,'其他參數中，參數名重複！',9) 
GO
