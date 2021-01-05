delete from HtmlLabelIndex where id=20063 
GO
delete from HtmlLabelInfo where indexid=20063 
GO
INSERT INTO HtmlLabelIndex values(20063,'请假申请单') 
GO
INSERT INTO HtmlLabelInfo VALUES(20063,'请假申请单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20063,'Leave Bill',8) 
GO

delete from HtmlLabelIndex where id=21624 
GO
delete from HtmlLabelInfo where indexid=21624 
GO
INSERT INTO HtmlLabelIndex values(21624,'本次所请年假天数大于用户可请年假天数，请修改请假时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(21624,'本次所请年假天数大于用户可请年假天数，请修改请假时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21624,'The annual leave days requested by the user may request more than a few days of annual leave,please modify the leave time',8) 
GO
delete from HtmlLabelIndex where id=21620 
GO
delete from HtmlLabelInfo where indexid=21620 
GO
INSERT INTO HtmlLabelIndex values(21620,'年假导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21620,'年假导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21620,'Annual leave loaded success!',8) 
GO
delete from HtmlLabelIndex where id=21600 
GO
delete from HtmlLabelInfo where indexid=21600 
GO
INSERT INTO HtmlLabelIndex values(21600,'年假设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21600,'年假设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21600,'Set annual leave',8) 
GO

delete from HtmlLabelIndex where id=21598 
GO
delete from HtmlLabelInfo where indexid=21598 
GO
INSERT INTO HtmlLabelIndex values(21598,'年假有效期设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21598,'年假有效期设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21598,'Set Annual leave period',8) 
GO
delete from HtmlLabelIndex where id=21590 
GO
delete from HtmlLabelInfo where indexid=21590 
GO
INSERT INTO HtmlLabelIndex values(21590,'年假管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(21590,'年假管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21590,'Management of annual leave',8) 
GO

delete from HtmlLabelIndex where id=21599 
GO
delete from HtmlLabelInfo where indexid=21599 
GO
INSERT INTO HtmlLabelIndex values(21599,'年假批量处理设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21599,'年假批量处理设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21599,'Annual Batch processing settings',8) 
GO

delete from HtmlLabelIndex where id=21614 
GO
delete from HtmlLabelInfo where indexid=21614 
GO
INSERT INTO HtmlLabelIndex values(21614,'上一年可请年假天数') 
GO
delete from HtmlLabelIndex where id=21615 
GO
delete from HtmlLabelInfo where indexid=21615 
GO
INSERT INTO HtmlLabelIndex values(21615,'今年剩余年假天数') 
GO
delete from HtmlLabelIndex where id=21616 
GO
delete from HtmlLabelInfo where indexid=21616 
GO
INSERT INTO HtmlLabelIndex values(21616,'当前可请年假天数') 
GO
INSERT INTO HtmlLabelInfo VALUES(21614,'上一年可请年假天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21614,'The previous year may request annual leave days',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21615,'今年剩余年假天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21615,'This year the number of days remaining annual leave',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21616,'当前可请年假天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21616,'Is currently available in a few days annual leave',8) 
GO

delete from HtmlLabelIndex where id=21612 
GO
delete from HtmlLabelInfo where indexid=21612 
GO
INSERT INTO HtmlLabelIndex values(21612,'年假批量处理失败，因为你没有对年假批量处理进行初始化设置，请设置！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21612,'年假批量处理失败，因为你没有对年假批量处理进行初始化设置，请设置！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21612,'Annual leave batch processing failure,Because you do not have the bulk of annual leave to deal with initialization settings, set up!',8) 
GO

delete from HtmlLabelIndex where id=21611 
GO
delete from HtmlLabelInfo where indexid=21611 
GO
INSERT INTO HtmlLabelIndex values(21611,'批量处理') 
GO
INSERT INTO HtmlLabelInfo VALUES(21611,'批量处理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21611,'Batch processing',8) 
GO
delete from HtmlLabelIndex where id=21609 
GO
delete from HtmlLabelInfo where indexid=21609 
GO
INSERT INTO HtmlLabelIndex values(21609,'请假类型颜色设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(21609,'请假类型颜色设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21609,'set color of leave type',8) 
GO

delete from HtmlLabelIndex where id=21602 
GO
delete from HtmlLabelInfo where indexid=21602 
GO
INSERT INTO HtmlLabelIndex values(21602,'年假') 
GO
INSERT INTO HtmlLabelInfo VALUES(21602,'年假',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21602,'Annual leave',8) 
GO

delete from SystemRights where id = 790
go
delete from SystemRightsLanguage where id = 790
go
delete from SystemRightDetail where id = 4300
go
insert into SystemRights (id,rightdesc,righttype) values (790,'请假类型颜色设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,7,'请假类型颜色设置','请假类型颜色设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (790,8,'set color of leave type','set color of leave type') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4300,'请假类型颜色设置','LeaveTypeColor:all',790) 
GO

delete from SystemRights where id = 789
go
delete from SystemRightsLanguage where id = 789
go
delete from SystemRightDetail where id = 4299
go
insert into SystemRights (id,rightdesc,righttype) values (789,'年假批量处理设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (789,8,'Annual Batch processing settings','Annual Batch processing settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (789,7,'年假批量处理设置','年假批量处理设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4299,'年假批量处理设置','AnnualBatch:All',789) 
GO

delete from SystemRights where id = 788
go
delete from SystemRightsLanguage where id = 788
go
delete from SystemRightDetail where id = 4298
go
insert into SystemRights (id,rightdesc,righttype) values (788,'年假有效期设置','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (788,8,'Set Annual leave period','Set Annual leave period') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (788,7,'年假有效期设置','年假有效期设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4298,'年假有效期设置','AnnualPeriod:All',788) 
GO

delete from SystemRights where id = 787
go
delete from SystemRightsLanguage where id = 787
go
delete from SystemRightDetail where id = 4297
go
insert into SystemRights (id,rightdesc,righttype) values (787,'年假管理','3') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (787,7,'年假管理','年假管理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (787,8,'Management of annual leave','Management of annual leave') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4297,'年假管理','AnnualLeave:All',787) 
GO

delete from HtmlLabelIndex where id=19517 
GO
delete from HtmlLabelInfo where indexid=19517 
GO
INSERT INTO HtmlLabelIndex values(19517,'年假天数') 
GO
INSERT INTO HtmlLabelInfo VALUES(19517,'年假天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19517,'Annual Days',8) 
GO

delete from HtmlLabelIndex where id=21669 
GO
delete from HtmlLabelInfo where indexid=21669 
GO
INSERT INTO HtmlLabelIndex values(21669,'您确定此设置同步到下级单位吗？此操作将覆盖所有下级单位的设置！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21669,'您确定此设置同步到下级单位吗？此操作将覆盖所有下级单位的设置！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21669,'Are you sure this setting simultaneously to the lower level units? This will cover all subordinate units set up!',8) 
GO
delete from HtmlLabelIndex where id=21670 
GO
delete from HtmlLabelInfo where indexid=21670 
GO
INSERT INTO HtmlLabelIndex values(21670,'您确定要删除吗？并同步到下级单位，此操作将删除所有下级单位的设置！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21670,'您确定要删除吗？并同步到下级单位，此操作将删除所有下级单位的设置！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21670,'Are you sure you want to delete it &raquo; And simultaneously to the lower-level units, this action will remove all lower-level units set up!',8) 
GO
delete from HtmlLabelIndex where id=21671 
GO
delete from HtmlLabelInfo where indexid=21671 
GO
INSERT INTO HtmlLabelIndex values(21671,'同步下级单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(21671,'同步下级单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21671,'Synchronization subordinate units',8) 
GO

delete from HtmlLabelIndex where id=21677 
GO
delete from HtmlLabelInfo where indexid=21677 
GO
INSERT INTO HtmlLabelIndex values(21677,'没有选择要同步的项！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21677,'没有选择要同步的项！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21677,'Did not choose to synchronize the items!',8) 
GO


delete from HtmlLabelIndex where id=21720 
GO
delete from HtmlLabelInfo where indexid=21720 
GO
INSERT INTO HtmlLabelIndex values(21720,'可请年假天数为0，不能请年假！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21720,'可请年假天数为0，不能请年假！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21720,'The annual leave you left is zero, you can not take annual leave!',8) 
GO
delete from HtmlLabelIndex where id=21721 
GO
delete from HtmlLabelInfo where indexid=21721 
GO
INSERT INTO HtmlLabelIndex values(21721,'本次所请年假天数大于您的可请年假天数，请修改请假时间！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21721,'本次所请年假天数大于您的可请年假天数，请修改请假时间！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21721,'The number of the annual leave you request is more than you left，please modify the time!',8) 
GO