delete from HtmlLabelIndex where id=21678 
GO
delete from HtmlLabelInfo where indexid=21678 
GO
INSERT INTO HtmlLabelIndex values(21678,'不显示空的意见') 
GO
INSERT INTO HtmlLabelInfo VALUES(21678,'不显示空的意见',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21678,'Not view null comments',8) 
GO