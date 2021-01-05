INSERT INTO HtmlLabelIndex values(17995,'是否邮件提醒')
/
INSERT INTO HtmlLabelInfo VALUES(17995,'是否邮件提醒',7)
/
INSERT INTO HtmlLabelInfo VALUES(17995,'mail reminding or not',8)
/


ALTER TABLE workflow_base ADD mailMessageType integer
/
update workflow_base set mailMessageType = 0
/