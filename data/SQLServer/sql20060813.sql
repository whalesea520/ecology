INSERT INTO HtmlLabelIndex values(19534,'文档创建报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(19534,'文档创建报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19534,'Doc Create Report',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 207,2
GO
EXECUTE MMInfo_Insert 521,19534,'','/docs/report/DocCreateRp.jsp','mainFrame',207,2,2,0,'',0,'',0,'','',0,'','',1
GO

INSERT INTO HtmlLabelIndex values(19547,'失效日期') 
GO
INSERT INTO HtmlLabelIndex values(19548,'生效日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(19547,'失效日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19547,'Invalid Date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19548,'生效日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19548,'Valid Date',8) 
GO
INSERT INTO HtmlLabelIndex values(19549,'编制部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(19549,'编制部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19549,'Authorized Department',8) 
GO

