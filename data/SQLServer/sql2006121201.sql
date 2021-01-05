DELETE FROM HtmlLabelIndex WHERE id=19995
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19995
GO

INSERT INTO HtmlLabelIndex VALUES(19995,'该名称模版已经存在，请重新输入新的名称！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19995,'该名称模版已经存在，请重新输入新的名称！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19995,'This name has existed,Please input another!',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19996
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19996
GO

INSERT INTO HtmlLabelIndex VALUES(19996,'源目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19996,'源目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19996,'Source Directory',8) 
GO
