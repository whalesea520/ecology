delete from HtmlLabelIndex where id=24752 
GO
delete from HtmlLabelInfo where indexid=24752 
GO
INSERT INTO HtmlLabelIndex values(24752,'登陆名中不能有“空格,分号,--,单引号”字符') 
GO
INSERT INTO HtmlLabelInfo VALUES(24752,'登陆名中不能有“空格,分号,--,单引号”字符',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24752,'Login name can''t have "space, semicolons, --, single quotes" character',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24752,'登錄名中不能有“空格,分號,--,單引號”字符',9) 
GO
