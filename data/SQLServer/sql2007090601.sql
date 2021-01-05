delete from HtmlLabelIndex where id = 20859
GO
delete from HtmlLabelInfo where indexId  = 20859
GO
INSERT INTO HtmlLabelIndex values(20859,'工作流未结束，请等待') 
GO
INSERT INTO HtmlLabelInfo VALUES(20859,'工作流未结束，请等待',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20859,'workflownotend',8) 
GO

delete from HtmlLabelIndex where id = 20887
GO
delete from HtmlLabelInfo where indexId = 20887
GO
INSERT INTO HtmlLabelIndex values(20887,'没有填写录用审批单据，请先填写') 
GO
INSERT INTO HtmlLabelInfo VALUES(20887,'没有填写录用审批单据，请先填写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20887,'WriteEmployFlow',8) 
GO