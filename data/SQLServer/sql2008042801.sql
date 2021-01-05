delete from HtmlLabelIndex where id=21418 
GO
delete from HtmlLabelInfo where indexid=21418 
GO
INSERT INTO HtmlLabelIndex values(21418,'签字意见附件上传目录') 
GO
delete from HtmlLabelIndex where id=21417 
GO
delete from HtmlLabelInfo where indexid=21417 
GO
INSERT INTO HtmlLabelIndex values(21417,'是否允许签字意见上传附件') 
GO
INSERT INTO HtmlLabelInfo VALUES(21417,'是否允许签字意见上传附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21417,'Whether to allow signature upload views of the annex',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21418,'签字意见附件上传目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21418,'Annex signature upload directory',8) 
GO

