DELETE FROM HtmlLabelIndex WHERE id = 20098
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20098
/
INSERT INTO HtmlLabelIndex values(20098,'工作人员') 
/
INSERT INTO HtmlLabelInfo VALUES(20098,'工作人员',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20098,'employee',8) 
/