delete from HtmlLabelIndex where id=21202 
GO
delete from HtmlLabelInfo where indexid=21202 
GO
INSERT INTO HtmlLabelIndex values(21202,'会议起止时间内会议室使用冲突，请更改会议时间或会议室！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21202,'会议起止时间内会议室使用冲突，请更改会议时间或会议室！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21202,'The beginning and ending time, the use of meeting rooms conflict, change the meeting time or conference room!',8) 
GO
delete from HtmlLabelIndex where id=21204 
GO
delete from HtmlLabelInfo where indexid=21204 
GO
INSERT INTO HtmlLabelIndex values(21204,'每页显示资产条数') 
GO
INSERT INTO HtmlLabelInfo VALUES(21204,'每页显示资产条数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21204,'Assets of several per page',8) 
GO