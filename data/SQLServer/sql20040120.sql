update workflow_bill set viewpage='ViewBillWeekworkinfo.jsp' where id = 17
GO


INSERT INTO HtmlLabelIndex values(17002,'邮件解析错误') 
GO
INSERT INTO HtmlLabelInfo VALUES(17002,'邮件解析错误',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17002,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17003,'密码已经清除') 
GO
INSERT INTO HtmlLabelInfo VALUES(17003,'密码已经清除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17003,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17004,'确定删除保存的密码？') 
GO
INSERT INTO HtmlLabelInfo VALUES(17004,'确定删除保存的密码？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17004,'',8) 
GO


/* 下面是对应的 oracle 语句 */
