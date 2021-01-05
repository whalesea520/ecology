delete from HtmlLabelIndex where id in (20029,20030)
/
delete from HtmlLabelInfo where indexid in (20029,20030)
/

INSERT INTO HtmlLabelIndex values(20029,'请先选择邮件。') 
/
INSERT INTO HtmlLabelInfo VALUES(20029,'请先选择邮件。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20029,'please select mail.',8) 
/
INSERT INTO HtmlLabelIndex values(20030,'即时通讯(IM)') 
/
INSERT INTO HtmlLabelInfo VALUES(20030,'即时通讯',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20030,'Instant Messaging',8) 
/