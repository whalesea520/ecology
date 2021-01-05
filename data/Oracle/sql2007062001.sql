delete from HtmlLabelIndex where id in(20509,20510,19113)
/
delete from HtmlLabelInfo where indexId in(20509,20510,19113)
/
INSERT INTO HtmlLabelIndex values(20509,'发文大类') 
/
INSERT INTO HtmlLabelIndex values(20510,'发文小类') 
/
INSERT INTO HtmlLabelInfo VALUES(20509,'发文大类',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20509,'Dispatch Abstract Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20510,'发文小类',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20510,'Dispatch Detail Type',8) 
/

INSERT INTO HtmlLabelIndex values(19113,'值') 
/
INSERT INTO HtmlLabelInfo VALUES(19113,'值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19113,'value',8) 
/
