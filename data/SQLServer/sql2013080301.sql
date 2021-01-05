delete from HtmlLabelIndex where id=31444 
GO
delete from HtmlLabelInfo where indexid=31444 
GO
INSERT INTO HtmlLabelIndex values(31444,'表单主表表名的别名为a，查询条件的格式为: a.a = ''1'' and a.b = ''3'' and a.c like ''%22%''') 
GO
INSERT INTO HtmlLabelInfo VALUES(31444,'表单主表表名的别名为a，查询条件的格式为: a.a = ''1'' and a.b = ''3'' and a.c like ''%22%''',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31444,'bill main table other name is a,search condition format is a.a = ''1'' and a.b = ''3'' and a.c like ''%22%''',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31444,'表單主表表名的别名爲a，查詢條件的格式爲: a.a = ''1'' and a.b = ''3'' and a.c like ''%22%''',9) 
GO
