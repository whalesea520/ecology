delete from HtmlLabelIndex where id=20420
go
delete from HtmlLabelInfo where indexid=20420
go

INSERT INTO HtmlLabelIndex values(20420,'是否生成项目日程') 
GO
INSERT INTO HtmlLabelInfo VALUES(20420,'是否生成项目日程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20420,'Build Work Plan',8) 
GO