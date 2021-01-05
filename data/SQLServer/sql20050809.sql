/*--------默认值为 -1 , 对新版本新数据而言, 当新建流程节点时, -1 代表默认为 "可查看所属流程的所有节点" --------*/
alter table workflow_flownode add viewnodeids  varchar(1000)  default '-1'
GO

/*--------针对旧版本老数据, 把所有流程的节点的查看范围预置为 "可查看所属流程的所有节点" --------*/
update workflow_flownode set viewnodeids = '-1'
GO


INSERT INTO HtmlLabelIndex values(17750,'日志查看范围') 
GO
INSERT INTO HtmlLabelInfo VALUES(17750,'日志查看范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17750,'range of workflow log tracing',8) 
GO

