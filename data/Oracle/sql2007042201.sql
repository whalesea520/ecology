delete from HtmlLabelIndex where id=20304
/
delete from HtmlLabelInfo where indexid=20304
/

INSERT INTO HtmlLabelIndex values(20304,'无主题') 
/
INSERT INTO HtmlLabelInfo VALUES(20304,'无主题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20304,'No Subject',8) 
/
UPDATE license set cversion = '4.000'
/