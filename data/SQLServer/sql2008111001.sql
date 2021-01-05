delete from HtmlLabelIndex where id=22051 
GO
delete from HtmlLabelInfo where indexid=22051 
GO
INSERT INTO HtmlLabelIndex values(22051,'自动触发') 
GO
delete from HtmlLabelIndex where id=22050 
GO
delete from HtmlLabelInfo where indexid=22050 
GO
INSERT INTO HtmlLabelIndex values(22050,'触发类型') 
GO
delete from HtmlLabelIndex where id=22052 
GO
delete from HtmlLabelInfo where indexid=22052 
GO
INSERT INTO HtmlLabelIndex values(22052,'手动触发') 
GO
delete from HtmlLabelIndex where id=22053 
GO
delete from HtmlLabelInfo where indexid=22053 
GO
INSERT INTO HtmlLabelIndex values(22053,'触发操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(22050,'触发类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22050,'Trigger Type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22050,'觸發類型',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22051,'自动触发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22051,'Trigger Automatically',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22051,'自動觸發',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22052,'手动触发',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22052,'Trigger Manually',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22052,'手動觸發',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22053,'触发操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22053,'Trigger Operation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22053,'觸發操作',9) 
GO

delete from HtmlLabelIndex where id=22064 
GO
delete from HtmlLabelInfo where indexid=22064 
GO
INSERT INTO HtmlLabelIndex values(22064,'触发子流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(22064,'触发子流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22064,'Trigger Sub Workflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22064,'觸發子流程',9) 
GO

delete from HtmlLabelIndex where id=22068 
GO
delete from HtmlLabelInfo where indexid=22068 
GO
INSERT INTO HtmlLabelIndex values(22068,'可查看副本节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(22068,'可查看副本节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22068,'The nodes those can view copies',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22068,'可查看副本節點',9) 
GO
