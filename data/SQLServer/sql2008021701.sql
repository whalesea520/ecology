delete from HtmlLabelIndex where id=21227 
GO
delete from HtmlLabelInfo where indexid=21227 
GO
INSERT INTO HtmlLabelIndex values(21227,'抄送(不需提交)') 
GO
INSERT INTO HtmlLabelInfo VALUES(21227,'抄送(不需提交)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21227,'make a copy(no submit)',8) 
GO

delete from HtmlLabelIndex where id=21228 
GO
delete from HtmlLabelInfo where indexid=21228 
GO
INSERT INTO HtmlLabelIndex values(21228,'抄送(需提交)') 
GO
INSERT INTO HtmlLabelInfo VALUES(21228,'抄送(需提交)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21228,'make a copy(submit)',8) 
GO 

delete from HtmlLabelIndex where id=21256 
GO
delete from HtmlLabelInfo where indexid=21256 
GO
INSERT INTO HtmlLabelIndex values(21256,'抄送说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(21256,'抄送者能查看该流程，但对流程的流转不产生影响，需提交的提交后转入已办事宜，不需提交的查看后即进入已办事宜，抄送没有条件不分批次。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21256,'The operator can view the workflow,but can not turn the workflow,after submiting if needed or viewing the workflow unprocessed will be a workflow processed.There is no conditinos and groups for this operator.',8) 
GO
