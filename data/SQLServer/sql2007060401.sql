DELETE FROM HtmlLabelIndex WHERE id = 20449
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20449
GO
INSERT INTO HtmlLabelIndex values(20449,'允许修改共享') 
GO
INSERT INTO HtmlLabelInfo VALUES(20449,'允许修改共享',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20449,'Can Edit Share Setting',8) 
GO
