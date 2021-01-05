DELETE FROM HtmlLabelIndex WHERE id = 2047
/
DELETE FROM HtmlLabelInfo WHERE indexId = 2047
/
INSERT INTO HtmlLabelIndex values(2047,'发件日期') 
/
INSERT INTO HtmlLabelInfo VALUES(2047,'发件日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(2047,'Sending Date',8) 
/