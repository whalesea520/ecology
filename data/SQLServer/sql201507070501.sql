delete from HtmlLabelIndex where id=3648 
GO
delete from HtmlLabelInfo where indexid=3648 
GO
INSERT INTO HtmlLabelIndex values(3648,'自动下线时长设置')
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'自动下线时长设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'AutoOffLine Time Settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3648,'自動下線時長設置',9) 
GO

delete from HtmlLabelIndex where id=3649
GO
delete from HtmlLabelInfo where indexid=3649 
GO
INSERT INTO HtmlLabelIndex values(3649,'启用自动下线')
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'启用自动下线',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'Enabled AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3649,'啟用自動下線',9) 
GO

delete from HtmlLabelIndex where id=3650
GO
delete from HtmlLabelInfo where indexid=3650 
GO
INSERT INTO HtmlLabelIndex values(3650,'允许在线时长')
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'允许在线时长',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'Allow AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3650,'允許在線時長',9) 
GO

delete from HtmlLabelIndex where id=3651
GO
delete from HtmlLabelInfo where indexid=3651 
GO
INSERT INTO HtmlLabelIndex values(3651,'提醒框出现时间')
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'提醒框出现时间',7)
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'Allow AutoOffLine Time',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(3651,'提醒框出現時間',9) 
GO

delete from ErrorMsgIndex where id=175
GO
delete from ErrorMsgInfo where indexid=175
GO
insert into ErrorMsgIndex values (175,'您已被管理员强制下线！')
GO
insert into ErrorMsgInfo values (175,'您已被管理员强制下线！',7)
GO
insert into ErrorMsgInfo values (175,'You have been forced to logoff administrator!',8)
GO 
insert into ErrorMsgInfo values(175,'您已被管理員強制下線！',9)
GO