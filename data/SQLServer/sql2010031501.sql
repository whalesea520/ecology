delete from HtmlLabelIndex where id=24406 
GO
delete from HtmlLabelInfo where indexid=24406 
GO
INSERT INTO HtmlLabelIndex values(24406,'informix数据库连接') 
GO
INSERT INTO HtmlLabelInfo VALUES(24406,'如果数据库类型为informix，则数据库名称请按“数据库名@$服务名”的格式输入，如testdb@$myserver',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24406,'database type is informix,databasename such as testdb@$myserver',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24406,'如果数据库类型为informix，则数据库名称请按“数据库名@$服务名”的格式输入，如testdb@$myserver',9) 
GO
