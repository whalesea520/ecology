delete from HtmlLabelIndex where id = 20859
/
delete from HtmlLabelInfo where indexId  = 20859
/
INSERT INTO HtmlLabelIndex values(20859,'工作流未结束，请等待') 
/
INSERT INTO HtmlLabelInfo VALUES(20859,'工作流未结束，请等待',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20859,'workflownotend',8) 
/

delete from HtmlLabelIndex where id = 20887
/
delete from HtmlLabelInfo where indexId = 20887
/
INSERT INTO HtmlLabelIndex values(20887,'没有填写录用审批单据，请先填写') 
/
INSERT INTO HtmlLabelInfo VALUES(20887,'没有填写录用审批单据，请先填写',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20887,'WriteEmployFlow',8) 
/