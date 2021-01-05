delete from HtmlLabelIndex where id=20483 
GO
delete from HtmlLabelInfo where indexid=20483 
GO
INSERT INTO HtmlLabelIndex values(20483,'统计时间段') 
GO
INSERT INTO HtmlLabelInfo VALUES(20483,'统计时间段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20483,'query times',8) 
GO
