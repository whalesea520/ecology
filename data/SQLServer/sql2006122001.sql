DELETE FROM HtmlLabelIndex WHERE id=19799
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19799
GO
INSERT INTO HtmlLabelIndex values(19799,'所属分部') 
GO
INSERT INTO HtmlLabelInfo VALUES(19799,'所属分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19799,'Belong Branch',8) 
GO
 
