delete from HtmlLabelIndex where id=21737 
GO
delete from HtmlLabelInfo where indexid=21737 
GO
INSERT INTO HtmlLabelIndex values(21737,'自定义右键按钮') 
GO
INSERT INTO HtmlLabelInfo VALUES(21737,'自定义右键按钮',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21737,'Custom Right Menu',8) 
GO
delete from HtmlLabelIndex where id=21738 
GO
delete from HtmlLabelInfo where indexid=21738 
GO
INSERT INTO HtmlLabelIndex values(21738,'同步到所有节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21738,'同步到所有节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21738,'synchronize to all nodes',8) 
GO
delete from HtmlLabelIndex where id=21740 
GO
delete from HtmlLabelInfo where indexid=21740 
GO
INSERT INTO HtmlLabelIndex values(21740,'表单字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(21740,'表单字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21740,'Form field',8) 
GO
delete from HtmlLabelIndex where id=21742 
GO
delete from HtmlLabelInfo where indexid=21742 
GO
INSERT INTO HtmlLabelIndex values(21742,'若流程节点操作人对所选流程没有新建权限，则该按钮不显示。') 
GO
delete from HtmlLabelIndex where id=21743 
GO
delete from HtmlLabelInfo where indexid=21743 
GO
INSERT INTO HtmlLabelIndex values(21743,'默认短信内容为：自定义内容+流程标题+所选表单字段的值，默认短信接收人为该节点其他操作人。如果流程节点操作人无新建短信权限，则该按钮不显示。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21742,'若流程节点操作人对所选流程没有新建权限，则该按钮不显示。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21742,'If no perview to create the workflow, no menu',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21743,'默认短信内容为：自定义内容+流程标题+所选表单字段的值，默认短信接收人为该节点其他操作人。如果流程节点操作人无新建短信权限，则该按钮不显示。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21743,'The default sms is custom content + request title + the value of the chosen form. If no perview to send sms, no menu.',8) 
GO
