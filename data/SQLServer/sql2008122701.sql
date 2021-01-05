delete from HtmlLabelIndex where id=22060 
GO
delete from HtmlLabelInfo where indexid=22060 
GO
INSERT INTO HtmlLabelIndex values(22060,'正在保存任务，请稍等....') 
GO
INSERT INTO HtmlLabelInfo VALUES(22060,'正在保存任务，请稍等....',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22060,'Saving task,waiting please....',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22060,'',9) 
GO