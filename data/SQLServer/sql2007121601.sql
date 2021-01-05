delete from HtmlLabelIndex where id=21192 
GO
delete from HtmlLabelInfo where indexid=21192 
GO
INSERT INTO HtmlLabelIndex values(21192,'标题（流程专用其他模块请勿使用）') 
GO
INSERT INTO HtmlLabelInfo VALUES(21192,'标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21192,'title',8) 
GO

delete from HtmlLabelIndex where id=1334 
GO
delete from HtmlLabelInfo where indexid=1334 
GO
INSERT INTO HtmlLabelIndex values(1334,'请求标题') 
GO
INSERT INTO HtmlLabelInfo VALUES(1334,'请求标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(1334,'Request Explain',8) 
GO