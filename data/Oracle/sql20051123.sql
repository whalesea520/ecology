/*0:pop3 , 1:imap*/
alter table SystemSet add receiveProtocolType char(1) 
/


update SystemSet set receiveProtocolType='0'
/

INSERT INTO HtmlLabelIndex values(18005,'重新登录') 
/
INSERT INTO HtmlLabelInfo VALUES(18005,'重新登录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18005,'ReLogin',8) 
/