delete from HtmlLabelIndex where id=22049 
GO
delete from HtmlLabelInfo where indexid=22049 
GO
INSERT INTO HtmlLabelIndex values(22049,'排除以下所选类型流程(一般会影响到系统性能)') 
GO
delete from HtmlLabelIndex where id=22048 
GO
delete from HtmlLabelInfo where indexid=22048 
GO
INSERT INTO HtmlLabelIndex values(22048,'显示以下所选类型流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(22048,'显示以下所选类型流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22048,'Show selected workflowType below',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22048,'显示以下所选类型流程',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22049,'排除以下所选类型流程(一般会影响到系统性能)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22049,'Exclude selected worflow type below',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22049,'排除以下所选类型流程(一般会影响到系统性能)',9) 
GO
