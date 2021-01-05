delete from HtmlLabelIndex where id in (20267, 20266, 20265)
/
delete from HtmlLabelInfo where indexid in (20267, 20266, 20265)
/

INSERT INTO HtmlLabelIndex values(20267,'进入我的邮件收取') 
/
INSERT INTO HtmlLabelIndex values(20266,'错误！请检查您的邮件帐户设置。') 
/
INSERT INTO HtmlLabelIndex values(20265,'正在读取邮件服务器上的新邮件') 
/
INSERT INTO HtmlLabelInfo VALUES(20265,'正在读取邮件服务器上的新邮件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20265,'Searching unread mails',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20266,'错误！请检查您的邮件帐户设置。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20266,'Error! Please check your setting.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20267,'进入我的邮件收取',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20267,'Get',8) 
/

update hpextElement set extshow='Mail.jsp' where id=16
/


delete from HtmlLabelIndex where id in (20265)
/
delete from HtmlLabelInfo where indexid in (20265)
/
INSERT INTO HtmlLabelIndex values(20265,'邮件服务器上的新邮件') 
/
INSERT INTO HtmlLabelInfo VALUES(20265,'邮件服务器上的新邮件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20265,'Unread mails',8) 
/