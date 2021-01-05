delete from HtmlLabelIndex where id=19134 
GO
delete from HtmlLabelInfo where indexid=19134 
GO
INSERT INTO HtmlLabelIndex values(19134,'审批中') 
GO
INSERT INTO HtmlLabelInfo VALUES(19134,'审批中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19134,'Approving',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19134,'審批中',9) 
GO


delete from HtmlLabelIndex where id=1423 
GO
delete from HtmlLabelInfo where indexid=1423 
GO
INSERT INTO HtmlLabelIndex values(1423,'已审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(1423,'已审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(1423,'Approved',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(1423,'Approved',9) 
GO