delete from HtmlLabelIndex where id=83348 
GO
delete from HtmlLabelInfo where indexid=83348 
GO
INSERT INTO HtmlLabelIndex values(83348,'表单主表表名的别名为t1，明细表表名的别名为d1，格式为: t1.a=''1'' and d1.b = ''3''。') 
GO
INSERT INTO HtmlLabelInfo VALUES(83348,'表单主表表名的别名为t1，明细表表名的别名为d1，格式为: t1.a=''1'' and d1.b = ''3''。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(83348,'Table name aliases for the primary table of the form T1, table name aliases for the schedule D1, in the format: T1.a=''1'' and D1.b = ''3''.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(83348,'表單主表表名的别名爲t1，明細表表名的别名爲d1，格式爲: t1.a=''1'' and d1.b = ''3''。',9) 
GO