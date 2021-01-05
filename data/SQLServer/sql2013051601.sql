delete from HtmlLabelIndex where id=31318 
GO
delete from HtmlLabelInfo where indexid=31318 
GO
INSERT INTO HtmlLabelIndex values(31318,'如果设置有外部明细表，则每个明细表须有一个字段设置关联外部主表主键字段。外部明细表条件设置成 “ where ''明细表.关联字段'' = ''主表.主键字段'' ”。') 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'如果设置有外部明细表，则每个明细表须有一个字段设置关联外部主表主键字段。外部明细表条件设置成 “ where ''明细表.关联字段'' = ''主表.主键字段'' ”。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'If you set detailtable, each detailtable shall have a field set associative external master table''s primary key field. Schedule of external conditions set the WHERE ''detailtable. RefId'' = ''maintable primary key''. "',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(31318,'如果設置有外部明細表，則每個明細表須有一個字段設置關聯外部主表主鍵字段。外部明細表條件設置成 “ where ''明細表.關聯字段'' = ''主表.主鍵字段'' ”。',9) 
GO
