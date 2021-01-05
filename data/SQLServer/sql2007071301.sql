
Delete HtmlLabelIndex where id=20549
GO
Delete HtmlLabelInfo where indexid=20549
GO
Delete HtmlLabelIndex where id=20550
GO
Delete HtmlLabelInfo where indexid=20550
GO
INSERT INTO HtmlLabelIndex values(20549,'搜索模板') 
GO
INSERT INTO HtmlLabelIndex values(20550,'搜索条件') 
GO
INSERT INTO HtmlLabelInfo VALUES(20549,'搜索模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20549,'Search Templet',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20550,'搜索条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20550,'Search Condition',8) 
GO

Delete HtmlLabelIndex where id=20568
GO
Delete HtmlLabelInfo where indexid=20568
GO
INSERT INTO HtmlLabelIndex values(20568,'包括回复文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(20568,'包括回复文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20568,'Include reply doc',8) 
GO



Delete HtmlLabelIndex where id=20532
GO
Delete HtmlLabelInfo where indexid=20532
GO
INSERT INTO HtmlLabelIndex values(20532,'文档来源') 
GO
INSERT INTO HtmlLabelInfo VALUES(20532,'文档来源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20532,'Doc Src',8) 
GO

Delete HtmlLabelIndex where id=20533
GO
Delete HtmlLabelInfo where indexid=20533
GO
INSERT INTO HtmlLabelIndex values(20533,'指定文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(20533,'指定文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20533,'Selected Docs',8) 
GO