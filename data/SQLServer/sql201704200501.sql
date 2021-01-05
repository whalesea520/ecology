delete from HtmlLabelIndex where id=130287 
GO
delete from HtmlLabelInfo where indexid=130287 
GO
INSERT INTO HtmlLabelIndex values(130287,'当前流程不是检测流程，不允许勾选') 
GO
INSERT INTO HtmlLabelInfo VALUES(130287,'当前流程不是检测流程，不允许勾选',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130287,'The current process is not the detection process, not allowed to check',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130287,'當前流程不是檢測流程，不允許勾選',9) 
GO


delete from HtmlLabelIndex where id=130288 
GO
delete from HtmlLabelInfo where indexid=130288 
GO
INSERT INTO HtmlLabelIndex values(130288,'委托书') 
GO
INSERT INTO HtmlLabelInfo VALUES(130288,'委托书',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130288,'A power of attorney',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130288,'委託書',9) 
GO

delete from HtmlLabelIndex where id=130289 
GO
delete from HtmlLabelInfo where indexid=130289 
GO
INSERT INTO HtmlLabelIndex values(130289,'检验') 
GO
INSERT INTO HtmlLabelInfo VALUES(130289,'检验',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130289,'test',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130289,'檢驗',9) 
GO