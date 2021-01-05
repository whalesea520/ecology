delete from HtmlLabelIndex where id=130262 
GO
delete from HtmlLabelInfo where indexid=130262 
GO
INSERT INTO HtmlLabelIndex values(130262,'越权访问') 
GO
INSERT INTO HtmlLabelInfo VALUES(130262,'越权访问',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130262,'exceeds authorized access',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130262,'越权访问',9) 
GO

delete from HtmlLabelIndex where id=130264 
GO
delete from HtmlLabelInfo where indexid=130264 
GO
INSERT INTO HtmlLabelIndex values(130264,'越权访问日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(130264,'越权访问日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130264,'Forbidden Access Log',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130264,'越权访问日志',9) 
GO

delete from HtmlLabelIndex where id=130266 
GO
delete from HtmlLabelInfo where indexid=130266 
GO
INSERT INTO HtmlLabelIndex values(130266,'日志空间限制') 
GO
INSERT INTO HtmlLabelInfo VALUES(130266,'日志空间限制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130266,'Max Log Space',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130266,'日志空间限制',9) 
GO