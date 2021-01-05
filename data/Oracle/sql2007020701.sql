DELETE FROM HtmlLabelIndex WHERE id = 20232
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20232
/
INSERT INTO HtmlLabelIndex values(20232,'上周开始') 
/
INSERT INTO HtmlLabelInfo VALUES(20232,'上周开始',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20232,'Begin Date in Last Week',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20233
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20233
/
INSERT INTO HtmlLabelIndex values(20233,'上月开始') 
/
INSERT INTO HtmlLabelInfo VALUES(20233,'上月开始',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20233,'Begin Date in Last Month',8) 
/

DELETE FROM HtmlLabelIndex WHERE id = 20234
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20234
/
INSERT INTO HtmlLabelIndex values(20234,'显示全部') 
/
INSERT INTO HtmlLabelInfo VALUES(20234,'显示全部',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20234,'Display All WorkPlan',8) 
/
