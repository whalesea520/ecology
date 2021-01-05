alter table MailResource add flag int
GO
delete from HtmlLabelIndex where id=125055 
GO
delete from HtmlLabelInfo where indexid=125055 
GO
INSERT INTO HtmlLabelIndex values(125055,'已转发') 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'已转发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'forwarded',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125055,'已轉發',9) 
GO
delete from HtmlLabelIndex where id=125056 
GO
delete from HtmlLabelInfo where indexid=125056 
GO
INSERT INTO HtmlLabelIndex values(125056,'已回复') 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'已回复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'replied',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125056,'已回複',9) 
GO
delete from HtmlLabelIndex where id=125057 
GO
delete from HtmlLabelInfo where indexid=125057 
GO
INSERT INTO HtmlLabelIndex values(125057,'已转发且已回复') 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'已转发且已回复',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'Have forwarded and reply',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125057,'已轉發且已回複',9) 
GO
delete from HtmlLabelIndex where id=24714 
GO
delete from HtmlLabelInfo where indexid=24714 
GO
INSERT INTO HtmlLabelIndex values(24714,'内部邮件') 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'内部邮件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'Inner Email',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24714,'內部郵件',9) 
GO