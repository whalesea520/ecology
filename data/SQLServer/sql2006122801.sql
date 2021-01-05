DELETE FROM HtmlLabelIndex WHERE id = 20074
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20074
GO
INSERT INTO HtmlLabelIndex values(20074,'你已输入') 
GO
INSERT INTO HtmlLabelInfo VALUES(20074,'你已输入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20074,'You have inputed',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20075
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20075
GO
INSERT INTO HtmlLabelIndex values(20075,'个字符') 
GO
INSERT INTO HtmlLabelInfo VALUES(20075,'个字符.',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20075,'words.',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20076
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20076
GO
INSERT INTO HtmlLabelIndex values(20076,'将被分成') 
GO
INSERT INTO HtmlLabelInfo VALUES(20076,'将被分成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20076,'The message amount will be',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id = 20097
GO
DELETE FROM HtmlLabelInfo WHERE indexId = 20097
GO
INSERT INTO HtmlLabelIndex values(20097,'条发送') 
GO
INSERT INTO HtmlLabelInfo VALUES(20097,'条发送',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20097,'',8) 
GO
