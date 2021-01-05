delete from HtmlLabelIndex where id=129666 
GO
delete from HtmlLabelInfo where indexid=129666 
GO
INSERT INTO HtmlLabelIndex values(129666,'查询条件是否展开') 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'查询条件是否展开',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'Whether the query conditions',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(129666,'查詢條件是否展開',9) 
GO
alter table mode_customsearch add isShowQueryCondition int
GO
