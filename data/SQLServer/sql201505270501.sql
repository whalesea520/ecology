delete from HtmlLabelIndex where id=84233 
GO
delete from HtmlLabelInfo where indexid=84233 
GO
INSERT INTO HtmlLabelIndex values(84233,'是否包含下级的值') 
GO
INSERT INTO HtmlLabelInfo VALUES(84233,'是否包含下级的值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84233,'contains the lower values',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84233,'是否包含下級的值',9) 
GO


delete from HtmlLabelIndex where id=84234 
GO
delete from HtmlLabelInfo where indexid=84234 
GO
INSERT INTO HtmlLabelIndex values(84234,'用在链接目标关联字段过滤查询列表时，过滤出的查询列表数据不仅包含自身还要包含自身的所有下级的值。') 
GO
INSERT INTO HtmlLabelInfo VALUES(84234,'用在链接目标关联字段过滤查询列表时，过滤出的查询列表数据不仅包含自身还要包含自身的所有下级的值。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84234,'Associated with a linked target field to filter queries list, filtered query list contains not only the data itself must contain all subordinate values itself.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84234,'用在鏈接目标關聯字段過濾查詢列表時，過濾出的查詢列表數據不僅包含自身還要包含自身的所有下級的值。',9) 
GO

delete from HtmlLabelIndex where id=84235 
GO
delete from HtmlLabelInfo where indexid=84235 
GO
INSERT INTO HtmlLabelIndex values(84235,'(仅在链接目标地址为查询列表，且链接目标关联字段不能为空的情况下生效)') 
GO
INSERT INTO HtmlLabelInfo VALUES(84235,'(仅在链接目标地址为查询列表，且链接目标关联字段不能为空的情况下生效)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84235,'(Only in a linked list of destination addresses for queries and associated link target field cannot be null and of entry into force)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84235,'(僅在鏈接目标地址爲查詢列表，且鏈接目标關聯字段不能爲空的情況下生效)',9) 
GO