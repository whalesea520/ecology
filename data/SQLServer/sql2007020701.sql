DELETE FROM HtmlLabelIndex WHERE id = 20232
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20232
GO
INSERT INTO HtmlLabelIndex values(20232,'上周开始') 
GO
INSERT INTO HtmlLabelInfo VALUES(20232,'上周开始',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20232,'Begin Date in Last Week',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20233
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20233
GO
INSERT INTO HtmlLabelIndex values(20233,'上月开始') 
GO
INSERT INTO HtmlLabelInfo VALUES(20233,'上月开始',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20233,'Begin Date in Last Month',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20234
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20234
GO
INSERT INTO HtmlLabelIndex values(20234,'显示全部') 
GO
INSERT INTO HtmlLabelInfo VALUES(20234,'显示全部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20234,'Display All WorkPlan',8) 
GO
