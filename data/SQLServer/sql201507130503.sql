update HtmlLabelInfo set labelname = 'Unread' where indexid = 83229 and languageid = 8 
GO
update HtmlLabelInfo set labelname = 'Important' where indexid = 83235 and languageid = 8 
GO
update HtmlLabelInfo set labelname = 'Reply' where indexid = 83236 and languageid = 8 
GO
update HtmlLabelInfo set labelname = 'Check' where indexid = 83237 and languageid = 8 
GO

alter table MailReceiveRemind add labelid VARCHAR(20)
GO
update MailReceiveRemind set labelid = '17586' where id = 1
GO
update MailReceiveRemind set labelid = '32812' where id = 2
GO
update MailReceiveRemind set labelid = '124901' where id = 3
GO
update MailReceiveRemind set labelid = '124902' where id = 4
GO