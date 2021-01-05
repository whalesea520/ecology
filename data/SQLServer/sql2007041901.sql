delete from HtmlLabelIndex where id=20303
GO
delete from HtmlLabelInfo where indexid=20303
GO
INSERT INTO HtmlLabelIndex values(20303,'是否替换原来的数据?') 
GO
INSERT INTO HtmlLabelInfo VALUES(20303,'是否替换原来的数据?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20303,'Whether replace primary data?',8) 
GO
