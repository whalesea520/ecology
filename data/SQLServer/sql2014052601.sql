
delete from HtmlLabelIndex where id=32025 
GO
delete from HtmlLabelInfo where indexid=32025 
GO
INSERT INTO HtmlLabelIndex values(32025,'撤回') 
GO
INSERT INTO HtmlLabelInfo VALUES(32025,'撤回',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32025,'recall',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32025,'撤回',9) 
GO
delete from HtmlLabelIndex where id=32412 
GO
delete from HtmlLabelInfo where indexid=32412 
GO
INSERT INTO HtmlLabelIndex values(32412,'已撤回') 
GO
INSERT INTO HtmlLabelInfo VALUES(32412,'已撤回',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32412,'Has withdrawn',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32412,'已撤回',9) 
GO
delete from HtmlLabelIndex where id=32436 
GO
delete from HtmlLabelInfo where indexid=32436 
GO
INSERT INTO HtmlLabelIndex values(32436,'是否确定撤回已发邮件，撤回后将无法恢复?') 
GO
INSERT INTO HtmlLabelInfo VALUES(32436,'是否确定撤回已发邮件，撤回后将无法恢复?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32436,'Whether email confirm withdraw, will not be able to recover after withdraw?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32436,'是否确定撤回已發郵件，撤回後将無法恢複?',9) 
GO