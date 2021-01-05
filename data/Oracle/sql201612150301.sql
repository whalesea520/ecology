delete from HtmlLabelIndex where id=129666 
/
delete from HtmlLabelInfo where indexid=129666 
/
INSERT INTO HtmlLabelIndex values(129666,'查询条件是否展开') 
/
INSERT INTO HtmlLabelInfo VALUES(129666,'查询条件是否展开',7) 
/
INSERT INTO HtmlLabelInfo VALUES(129666,'Whether the query conditions',8) 
/
INSERT INTO HtmlLabelInfo VALUES(129666,'查詢條件是否展開',9) 
/
alter table mode_customsearch add isShowQueryCondition integer
/