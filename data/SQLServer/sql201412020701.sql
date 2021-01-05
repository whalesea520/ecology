delete from HtmlLabelIndex where id=33976 
GO
delete from HtmlLabelInfo where indexid=33976 
GO
INSERT INTO HtmlLabelIndex values(33976,'日程日历显示时间段') 
GO
delete from HtmlLabelIndex where id=33990 
GO
delete from HtmlLabelInfo where indexid=33990 
GO
INSERT INTO HtmlLabelIndex values(33990,'上午开始时间不能小于时间段的开始时间') 
GO
delete from HtmlLabelIndex where id=33994 
GO
delete from HtmlLabelInfo where indexid=33994 
GO
INSERT INTO HtmlLabelIndex values(33994,'下午结束时间不能大于时间段的结束时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(33976,'日程日历显示时间段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33976,'Calendar display interval',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33976,'日程日曆顯示時間段',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(33990,'上午开始时间不能小于时间段的开始时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33990,'Calendar display interval start time cannot be greater than the AM start time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33990,'上午開始時間不能小于時間段的開始時間',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(33994,'下午结束时间不能大于时间段的结束时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33994,'Calendar display interval end time cannot be greater than the end of the afternoon time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33994,'下午結束時間不能大于時間段的結束時間',9) 
GO 
