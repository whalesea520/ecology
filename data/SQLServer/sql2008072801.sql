delete from HtmlLabelIndex where id=21717 
GO
delete from HtmlLabelInfo where indexid=21717 
GO
INSERT INTO HtmlLabelIndex values(21717,'触发流程时，可区分字段的值不能为空，否则触发不了流程。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21717,'触发流程时，可区分字段的值不能为空，否则触发不了流程。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21717,'When triggering workflow, the value of differentiable field can not be empty,or it can not trigger workflow.',8) 
GO


delete from HtmlLabelIndex where id=21719 
GO
delete from HtmlLabelInfo where indexid=21719 
GO
INSERT INTO HtmlLabelIndex values(21719,'重新生成附件') 
GO
delete from HtmlLabelIndex where id=21718 
GO
delete from HtmlLabelInfo where indexid=21718 
GO
INSERT INTO HtmlLabelIndex values(21718,'重新生成文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(21718,'重新生成文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21718,'Create Doc Again',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21719,'重新生成附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21719,'Create Accessory Again',8) 
GO
