delete from HtmlLabelIndex where id=20152
go
delete from HtmlLabelInfo where indexid=20152
go

delete from HtmlLabelIndex where id=20153
go
delete from HtmlLabelInfo where indexid=20153
go
delete from HtmlLabelIndex where id=20154
go
delete from HtmlLabelInfo where indexid=20154
go
INSERT INTO HtmlLabelIndex values(20152,'请选择大额委员会指定的供应商！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20152,'请选择大额委员会指定的供应商！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20152,'you must choose the provider confirm by Gig Sum Committee',8) 
GO

INSERT INTO HtmlLabelIndex values(20153,'动支金额(成本分摊)') 
GO
INSERT INTO HtmlLabelIndex values(20154,'报销金额(成本分摊)') 
GO
INSERT INTO HtmlLabelInfo VALUES(20153,'动支金额(成本分摊)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20153,'apply amount(cost apportion)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20154,'报销金额(成本分摊)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20154,'wipe amount(cost apportion)',8) 
GO