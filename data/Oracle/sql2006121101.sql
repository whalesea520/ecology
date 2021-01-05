DELETE FROM HtmlLabelIndex WHERE id=19990
/
DELETE FROM HtmlLabelInfo WHERE indexid=19990
/
DELETE FROM HtmlLabelIndex WHERE id=19991
/
DELETE FROM HtmlLabelInfo WHERE indexid=19991
/
DELETE FROM HtmlLabelIndex WHERE id=19992
/
DELETE FROM HtmlLabelInfo WHERE indexid=19992
/
INSERT INTO HtmlLabelIndex values(19990,'确认是否提交?') 
/
INSERT INTO HtmlLabelIndex values(19992,'确认是否转发?') 
/
INSERT INTO HtmlLabelIndex values(19991,'确认是否退回?') 
/
INSERT INTO HtmlLabelInfo VALUES(19990,'确认是否提交?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19990,'sure to submit?',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19991,'确认是否退回?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19991,'sure to back?',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19992,'确认是否转发?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19992,'sure to transmit?',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=19998
/
DELETE FROM HtmlLabelInfo WHERE indexid=19998
/
DELETE FROM HtmlLabelIndex WHERE id=20011
/
DELETE FROM HtmlLabelInfo WHERE indexid=20011
/
DELETE FROM HtmlLabelIndex WHERE id=20012
/
DELETE FROM HtmlLabelInfo WHERE indexid=20012
/
INSERT INTO HtmlLabelIndex values(19998,'附件大小') 
/
INSERT INTO HtmlLabelInfo VALUES(19998,'附件大小',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19998,'size of accessory',8) 
/
INSERT INTO HtmlLabelIndex values(20011,'附件合计大小') 
/
INSERT INTO HtmlLabelIndex values(20012,'附件单个大小') 
/
INSERT INTO HtmlLabelInfo VALUES(20011,'附件合计大小',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20011,'size of all accessory',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20012,'附件单个大小',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20012,'size of single accessory',8) 
/
