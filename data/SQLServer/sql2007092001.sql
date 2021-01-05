delete from HtmlLabelIndex where id=20895 
GO
delete from HtmlLabelInfo where indexid=20895 
GO
delete from HtmlLabelIndex where id=20896 
GO
delete from HtmlLabelInfo where indexid=20896 
GO

INSERT INTO HtmlLabelIndex values(20895,'直接打开附件') 
GO
INSERT INTO HtmlLabelIndex values(20896,'当文档内容为空，且此文档仅有一个附件时') 
GO
INSERT INTO HtmlLabelInfo VALUES(20895,'直接打开附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20895,'Open Accessory Directness',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20896,'当文档内容为空，且此文档仅有一个附件时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20896,'Doccontent is empty ,And this is only one accessory',8) 
GO
