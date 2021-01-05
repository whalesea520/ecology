delete from HtmlLabelIndex where id=3000 
GO
delete from HtmlLabelInfo where indexid=3000 
GO
INSERT INTO HtmlLabelIndex values(3000,'归档日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(3000,'归档日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(3000,'File Date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3000,'File Date',9) 
GO

delete from HtmlLabelIndex where id=126596 
GO
delete from HtmlLabelInfo where indexid=126596 
GO
INSERT INTO HtmlLabelIndex values(126596,'流程导出为文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(126596,'流程导出为文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126596,'Process is exported as a document',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126596,'流程導出爲文檔',9) 
GO

delete from HtmlLabelIndex where id=126597 
GO
delete from HtmlLabelInfo where indexid=126597 
GO
INSERT INTO HtmlLabelIndex values(126597,'您确认将这些流程导出为文档吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(126597,'您确认将这些流程导出为文档吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126597,'Do you confirm that these processes are exported as documents?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126597,'您确認将這些流程導出爲文檔嗎？',9) 
GO