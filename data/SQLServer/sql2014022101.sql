delete from HtmlLabelIndex where id=31318 
GO
delete from HtmlLabelInfo where indexid=31318 
GO
INSERT INTO HtmlLabelIndex values(31318,'外部明细表数据如需与主表数据关联，可将外部明细表条件设置为“where ''明细表.字段''=''主表.字段''”。') 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'外部明细表数据如需与主表数据关联，可将外部明细表条件设置为“where ''明细表.字段''=''主表.字段''”。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'If you set detailtable, each detailtable can have a field set associative external master table''s field. Schedule of external conditions set the WHERE ''detailtable. RefId'' = ''maintable.Field''. "',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'外部明細表數據如需與主表數據關聯，可将外部明細表條件設置爲“where ''明細表.字段''=''主表.字段''”。',9) 
GO