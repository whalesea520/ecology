delete from HtmlLabelIndex where id=21571 
GO
delete from HtmlLabelInfo where indexid=21571 
GO
INSERT INTO HtmlLabelIndex values(21571,'是否允许转会签') 
GO
INSERT INTO HtmlLabelInfo VALUES(21571,'是否允许转会签',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21571,'Whether to allow transfer executed',8) 
GO
delete from HtmlLabelIndex where id=21572 
GO
delete from HtmlLabelInfo where indexid=21572 
GO
INSERT INTO HtmlLabelIndex values(21572,'转会签') 
GO
INSERT INTO HtmlLabelInfo VALUES(21572,'转会签',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21572,'Signed transfer',8) 
GO
delete from HtmlLabelIndex where id=21573 
GO
delete from HtmlLabelInfo where indexid=21573 
GO
INSERT INTO HtmlLabelIndex values(21573,'转会签接收人还未全部提交') 
GO
INSERT INTO HtmlLabelInfo VALUES(21573,'转会签接收人还未全部提交',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21573,'There are no submit to sign receiver',8) 
GO
