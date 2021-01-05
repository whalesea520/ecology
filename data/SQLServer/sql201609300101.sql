delete from HtmlLabelIndex where id=128725 
GO
delete from HtmlLabelInfo where indexid=128725 
GO
INSERT INTO HtmlLabelIndex values(128725,'包含下级') 
GO
INSERT INTO HtmlLabelInfo VALUES(128725,'包含下级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128725,'iscontains',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128725,'包含下級',9) 
GO
