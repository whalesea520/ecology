delete from HtmlLabelIndex where id=21123 
GO
delete from HtmlLabelInfo where indexid=21123 
GO
INSERT INTO HtmlLabelIndex values(21123,'保险起始时间大于到期时间，请修改！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21123,'保险起始时间大于到期时间，请修改！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21123,'Starting time than insurance due time, please amend!',8) 
GO