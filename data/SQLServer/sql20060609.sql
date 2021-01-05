INSERT INTO HtmlLabelIndex values(19146,'资产入库验收提醒') 
GO
INSERT INTO HtmlLabelIndex values(19153,'工作流完成') 
GO
INSERT INTO HtmlLabelIndex values(19148,'人员入职提醒') 
GO
INSERT INTO HtmlLabelIndex values(19149,'合同到期提醒') 
GO
INSERT INTO HtmlLabelIndex values(19150,'提交报告提醒') 
GO
INSERT INTO HtmlLabelIndex values(19152,'目标建立提醒') 
GO
INSERT INTO HtmlLabelIndex values(19154,'新到达流程') 
GO
INSERT INTO HtmlLabelIndex values(19147,'工作流超时提醒') 
GO
INSERT INTO HtmlLabelIndex values(19151,'计划建立提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(19146,'资产入库验收提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19146,'Asset Import Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19147,'工作流超时提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19147,'Workflow Overtime',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19148,'人员入职提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19148,'PersonnelJoin Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19149,'合同到期提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19149,'Contract Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19150,'提交报告提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19150,'Submit Report Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19151,'计划建立提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19151,'Workplan Add Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19152,'目标建立提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19152,'Goal Add Remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19153,'工作流完成',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19153,'Workflow Finished',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19154,'新到达流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19154,'New Workflow',8) 
GO

delete from HtmlLabelIndex where id=17534
go
delete from HtmlLabelInfo where indexid=17534
go
INSERT INTO HtmlLabelIndex values(17534,'生日提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17534,'生日提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17534,'Birthday Remind',8) 
GO


update SysPoppupInfo set description='19154',typedescription='19154' where type=0
GO
update SysPoppupInfo set description='19153',typedescription='19153' where type=1
GO
update SysPoppupInfo set description='17534',typedescription='17534' where type=2
GO
update SysPoppupInfo set description='19152',typedescription='19152' where type=3
GO
update SysPoppupInfo set description='19151',typedescription='19151' where type=4
GO
update SysPoppupInfo set description='19150',typedescription='19150' where type=5
GO
update SysPoppupInfo set description='18710',typedescription='18710' where type=6
GO
update SysPoppupInfo set description='19149',typedescription='19149' where type=7
GO
update SysPoppupInfo set description='19148',typedescription='19148' where type=8
GO
update SysPoppupInfo set description='18822',typedescription='18822' where type=9
GO
update SysPoppupInfo set description='19147',typedescription='19147' where type=10
GO
update SysPoppupInfo set description='19146',typedescription='19146' where type=11
GO