delete from HtmlLabelIndex where id in (20029,20030)
go
delete from HtmlLabelInfo where indexid in (20029,20030)
go

INSERT INTO HtmlLabelIndex values(20029,'请先选择邮件。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20029,'请先选择邮件。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20029,'please select mail.',8) 
GO
INSERT INTO HtmlLabelIndex values(20030,'即时通讯(IM)') 
GO
INSERT INTO HtmlLabelInfo VALUES(20030,'即时通讯',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20030,'Instant Messaging',8) 
GO