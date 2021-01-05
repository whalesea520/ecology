delete from HtmlLabelIndex where id=23773 
GO
delete from HtmlLabelInfo where indexid=23773 
GO
INSERT INTO HtmlLabelIndex values(23773,'流程中') 
GO
delete from HtmlLabelIndex where id=23774 
GO
delete from HtmlLabelInfo where indexid=23774 
GO
INSERT INTO HtmlLabelIndex values(23774,'已完成') 
GO
INSERT INTO HtmlLabelInfo VALUES(23773,'流程中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23773,'workflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23773,'流程中',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(23774,'已完成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23774,'Completed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23774,'已完成',9) 
GO
