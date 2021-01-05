delete from HtmlLabelIndex where id in(20509,20510,19113)
GO
delete from HtmlLabelInfo where indexId in(20509,20510,19113)
GO
INSERT INTO HtmlLabelIndex values(20509,'发文大类') 
GO
INSERT INTO HtmlLabelIndex values(20510,'发文小类') 
GO
INSERT INTO HtmlLabelInfo VALUES(20509,'发文大类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20509,'Dispatch Abstract Type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20510,'发文小类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20510,'Dispatch Detail Type',8) 
GO

INSERT INTO HtmlLabelIndex values(19113,'值') 
GO
INSERT INTO HtmlLabelInfo VALUES(19113,'值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19113,'value',8) 
GO
