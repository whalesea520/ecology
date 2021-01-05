DELETE FROM HtmlLabelIndex WHERE id = 20354
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20354
GO
DELETE FROM HtmlLabelIndex WHERE id = 20347
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 2047
GO
INSERT INTO HtmlLabelIndex values(20354,'职位时限') 
GO
INSERT INTO HtmlLabelIndex values(20347,'工作区域') 
GO
INSERT INTO HtmlLabelInfo VALUES(20347,'工作区域',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20347,'Workspace',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20354,'职位时限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20354,'Duty Limit',8) 
GO