delete from HtmlLabelIndex where id=81749 
GO
delete from HtmlLabelInfo where indexid=81749 
GO
INSERT INTO HtmlLabelIndex values(81749,'你是这封邮件的密送人，所以不会显示在收件人中。') 
GO
INSERT INTO HtmlLabelInfo VALUES(81749,'你是这封邮件的密送人，所以不会显示在收件人中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81749,'Are you this email to send people, so will not display in the recipient.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81749,'你是這封郵件的密送人，所以不會顯示在收件人中。',9) 
GO