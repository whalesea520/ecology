DELETE FROM HtmlLabelIndex WHERE id = 20413
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20413
GO
INSERT INTO HtmlLabelIndex values(20413,'个人文档统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(20413,'个人文档统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20413,'Personal Document Report',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20414
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20414
GO
INSERT INTO HtmlLabelIndex values(20414,'部门文档统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(20414,'部门文档统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20414,'Department Document Report',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20415
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20415
GO
INSERT INTO HtmlLabelIndex values(20415,'分部文档统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(20415,'分部文档统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20415,'Subcompany Document Report',8) 
GO