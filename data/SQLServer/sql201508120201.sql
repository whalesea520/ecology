delete from HtmlLabelIndex where id=125346 
GO
delete from HtmlLabelInfo where indexid=125346 
GO
INSERT INTO HtmlLabelIndex values(125346,'该邮件附件已丢失，无法转发') 
GO
INSERT INTO HtmlLabelInfo VALUES(125346,'该邮件附件已丢失，无法转发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125346,'The email attachments has been lost, cannot be forwarded',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125346,'該郵件附件已丢失，無法轉發',9) 
GO

delete from HtmlLabelIndex where id=125347 
GO
delete from HtmlLabelInfo where indexid=125347 
GO
INSERT INTO HtmlLabelIndex values(125347,'无法在服务器上找到附件，或附件已丢失') 
GO
INSERT INTO HtmlLabelInfo VALUES(125347,'无法在服务器上找到附件，或附件已丢失',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125347,'Unable to find the attachment on the server, or attachment was lost',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125347,'無法在服務器上找到附件，或附件已丢失',9) 
GO

delete from HtmlLabelIndex where id=125348 
GO
delete from HtmlLabelInfo where indexid=125348 
GO
INSERT INTO HtmlLabelIndex values(125348,'找不到附件') 
GO
INSERT INTO HtmlLabelInfo VALUES(125348,'找不到附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125348,'Can''t find the attachment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125348,'找不到附件',9) 
GO
