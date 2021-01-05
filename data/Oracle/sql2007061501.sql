delete from HtmlLabelIndex where id in (20494,20495,20496)
/
delete from HtmlLabelInfo where indexid in (20494,20495,20496)
/

INSERT INTO HtmlLabelIndex values(20494,'重新解析') 
/
INSERT INTO HtmlLabelIndex values(20495,'正在解析邮件，请稍候...') 
/
INSERT INTO HtmlLabelInfo VALUES(20494,'重新解析',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20494,'Re-Parse',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20495,'正在解析邮件，请稍候...',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20495,'Parsing, Please wait...',8) 
/
INSERT INTO HtmlLabelIndex values(20496,'确定重新解析邮件吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(20496,'确定重新解析邮件吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20496,'Do you confirm re-parse the mail?',8) 
/
