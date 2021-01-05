delete from HtmlLabelIndex where id = 19437
GO
delete from HtmlLabelInfo where indexid = 19437
GO
INSERT INTO HtmlLabelIndex values(19437,'指定分部')
GO
INSERT INTO HtmlLabelInfo VALUES(19437,'指定分部',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19437,'appointe subcompany',8)
GO

delete from HtmlLabelIndex where id in (20868,20869,20870,20871,20872)
GO
delete from HtmlLabelInfo where indexid in (20868,20869,20870,20871,20872)
GO
INSERT INTO HtmlLabelIndex values(20868,'客户联系人申请流转单')
GO
INSERT INTO HtmlLabelIndex values(20869,'邮箱') 
GO
INSERT INTO HtmlLabelIndex values(20870,'直线') 
GO
INSERT INTO HtmlLabelIndex values(20871,'分机') 
GO
INSERT INTO HtmlLabelIndex values(20872,'自我介绍') 
GO
INSERT INTO HtmlLabelInfo VALUES(20868,'客户联系人申请流转单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20869,'邮箱',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20870,'直线',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20871,'分机',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20872,'自我介绍',7) 
GO

delete from HtmlLabelIndex where id = 20873
GO
delete from HtmlLabelInfo where indexid = 20873
GO
INSERT INTO HtmlLabelIndex values(20873,'初始化') 
GO
INSERT INTO HtmlLabelInfo VALUES(20873,'初始化',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20873,'initialize',8) 
GO

delete from HtmlLabelIndex where id = 20874
GO
delete from HtmlLabelInfo where indexid = 20874
GO
INSERT INTO HtmlLabelIndex values(20874,'要删除的联系人') 
GO
INSERT INTO HtmlLabelInfo VALUES(20874,'要删除的联系人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20874,'Contacter To Delete',8) 
GO

delete from HtmlLabelIndex where id = 20875
GO
delete from HtmlLabelInfo where indexid = 20875
GO
INSERT INTO HtmlLabelIndex values(20875,'只能设置一个联系人为主联系人') 
GO
INSERT INTO HtmlLabelInfo VALUES(20875,'只能设置一个联系人为主联系人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20875,'Only can set one contacter to main contacter',8) 
GO

delete from HtmlLabelIndex where id = 20876
GO
delete from HtmlLabelInfo where indexid = 20876
GO
INSERT INTO HtmlLabelIndex values(20876,'要初始化的联系人') 
GO
INSERT INTO HtmlLabelInfo VALUES(20876,'要初始化的联系人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20876,'Contacter To Initialize',8) 
GO

delete from HtmlLabelIndex where id = 20877
GO
delete from HtmlLabelInfo where indexid = 20877
GO
INSERT INTO HtmlLabelIndex values(20877,'您的联系人帐号申请成功') 
GO
INSERT INTO HtmlLabelInfo VALUES(20877,'您的联系人帐号申请成功',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20877,'The Accounts Application of Contacter Has Been Succeeded',8) 
GO

delete from HtmlLabelIndex where id in (20878,20879,20880)
GO
delete from HtmlLabelInfo where indexid in (20878,20879,20880)
GO
INSERT INTO HtmlLabelIndex values(20878,'您的用户名') 
GO
INSERT INTO HtmlLabelIndex values(20880,'系统登录地址') 
GO
INSERT INTO HtmlLabelIndex values(20879,'您的口令') 
GO
INSERT INTO HtmlLabelInfo VALUES(20878,'您的用户名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20878,'Your Login Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20879,'您的口令',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20879,'Your Password',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20880,'系统登录地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20880,'System Login URL',8) 
GO

delete from HtmlLabelIndex where id = 20883
GO
delete from HtmlLabelInfo where indexid = 20883
GO
INSERT INTO HtmlLabelIndex values(20883,'联系人审批工作流') 
GO
INSERT INTO HtmlLabelInfo VALUES(20883,'联系人审批工作流',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20883,'Contacter Confirm Workflow',8) 
GO

delete from HtmlLabelIndex where id = 20884
GO
delete from HtmlLabelInfo where indexid = 20884
GO
INSERT INTO HtmlLabelIndex values(20884,'客户联系人申请发生错误，请联系系统管理人员!') 
GO
INSERT INTO HtmlLabelInfo VALUES(20884,'客户联系人申请发生错误，请联系系统管理人员!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20884,'There are some error during application , Please contact web admin!',8) 
GO

delete from HtmlLabelIndex where id=20893 
GO
delete from HtmlLabelInfo where indexid=20893 
GO
INSERT INTO HtmlLabelIndex values(20893,'您的联系人帐号申请失败') 
GO
INSERT INTO HtmlLabelInfo VALUES(20893,'您的联系人帐号申请失败',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20893,'The Accounts Application of Contacter Is Faild',8) 
GO

delete from HtmlLabelIndex where id=20894 
GO
delete from HtmlLabelInfo where indexid=20894 
GO
INSERT INTO HtmlLabelIndex values(20894,'客户联系人申请提交成功!') 
GO
INSERT INTO HtmlLabelInfo VALUES(20894,'客户联系人申请提交成功!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20894,'The application has been submitted!',8) 
GO
