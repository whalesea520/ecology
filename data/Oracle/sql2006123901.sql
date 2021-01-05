delete from HtmlLabelIndex where id in (19516)
/
delete from HtmlLabelInfo where indexid in (19516)
/
delete from HtmlLabelIndex where id in (20151)
/
delete from HtmlLabelInfo where indexid in (20151)
/

INSERT INTO HtmlLabelIndex values(19516,'自定义') 
/
INSERT INTO HtmlLabelInfo VALUES(19516,'自定义',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19516,'user-defined',8) 
/
INSERT INTO HtmlLabelIndex values(20151,'包含被引用的记录，不能删除。') 
/
INSERT INTO HtmlLabelInfo VALUES(20151,'包含被引用的记录，不能删除。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20151,'can not delete.',8) 
/