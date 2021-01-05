alter table HrmResource add notallot int
GO
alter table HrmResource add beforefrozen int
GO
alter table HrmResource add resourcefrom varchar(100)
GO
alter table HrmResource add isnewuser varchar(100)
GO
create table rdeployhrmsetting(
	setname varchar(100),
	setvalue varchar(1000)
)
GO
insert into rdeployhrmsetting(setname,setvalue) values('subcom','')
GO
insert into rdeployhrmsetting(setname,setvalue) values('onoff','1')
GO
insert into rdeployhrmsetting(setname,setvalue) values('hostadd','192.168.7.200:8080')
GO
create table rdeployhrmsendmsg(
	resourceid int,
	sendtime varchar(50)
)
GO

create table user_model_config(
    userid int,
    modelid int,
    orderindex int
)
go
CREATE TABLE system_model_base (
	id INT PRIMARY KEY,
	modelname VARCHAR(1000),
	modelDESC VARCHAR(1000),
 	modeldetaildesc VARCHAR(4000),
	modelicosrc varchar(1000),
	mgrpage VARCHAR(1000)
)
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (1, '任务', '私人任务&团队任务，便捷的任务管理应用', '1、快速创建任务,分享文档资料，发表建议和想法，并与同事交流、互动 
2、任务进展情况一目了然，提供各种视图查看待办事项
3、团队任务可分级管理，多级复杂任务也能安排得井井有条', '/rdeploy/assets/img/cproj/btask.png')
go


INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc, mgrpage)
VALUES (2, '流程', '有效管理公司内部各项事务的办理', '1、灵活的流转环节及参与人设置确保流程能够快速高效地流转，每项事务的办理情况可在流程图中直观查看
2、强大的表单设计功能满足各种样式需求，实现完美无纸化办公
3、严格的权限判定确保信息的安全
4、丰富的消息提醒机制让用户随时随地掌握流程进展情况
5、支持多种接口，确保与其他模块或软件数据的流畅交互', '/rdeploy/assets/img/cproj/bworkflow.png'
, '/rdeploy/wf/index.jsp')
go

INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc, mgrpage)
VALUES (3, '网盘', '方便快捷的文件存储、分享平台', '1、公共目录确保所有用户可以共享各自的资源，做到信息互补，形成团队知识库
2、私人目录提供了保存个人文件的空间，再也不用随身带U盘
3、严谨的权限控制，确保重要文件不外流', '/rdeploy/assets/img/cproj/bdoc.png'
, '/rdeploy/doc/index.jsp')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (4, '必达', '有令必达，确保重要的内容相关人员确实收到', '1、能确保交流对象确实接收到相关消息，已读未读情况尽在掌握
2、提供应用内提醒、短信方式等多种提醒方式提醒接收人进行查阅
3、对每条提醒内容均可单独讨论交流', '/rdeploy/assets/img/cproj/bbing.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (5, '客户', '让客户资源的管理和维护变得简单', '1、统一管理分配给您的客户资源、下属的客户跟踪情况也能方便查看
2、客户联系人信息实时更新，关键联系人一手掌握
3、重要客户联系人生日、联系计划等让系统自动提醒您，贴心的客户关怀简单实现', '/rdeploy/assets/img/cproj/bcstom.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (6, '日程', '您的贴心小助理，帮您管理好您的所有行程计划', '1、短信提醒、邮件提醒等各种提醒方式，让您不会忘记任何重要事项
2、通过日程共享让其他用户可以了解您的工作安排，不会在您不方便的时候打扰到您
3、可以直接给下级安排日程并监督完成情况', '/rdeploy/assets/img/cproj/bschedule.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (7, '日志', '记录个人每天的工作内容及心得体会', '1、每个用户都可以记录各自的工作日志
2、通过分享关注可以查看其他人的工作日志，方便上级了解下级的工作状态
3、通过评论可以对其他人的工作发表自己的意见', '/rdeploy/assets/img/cproj/blog.png')
go

CREATE TABLE Workflow_RecordMesConfig
(
	userid            INT
)
GO
CREATE TABLE Workflow_RecordNavigation
(
	userid            INT
)
GO

INSERT INTO Workflow_Initialization(wfid, orderid) 
SELECT id,0 FROM workflow_base WHERE (isvalid = 0 OR isvalid=1) AND id != 1
GO

CREATE TABLE CHECKIN_USER_SECCATEGORY (
userid int NOT NULL ,
seccategory int NOT NULL 
)
GO

ALTER TABLE DocDetail ADD docVestIn int NOT NULL DEFAULT 0 
GO
ALTER TABLE DocSecCategory ADD seccategoryType int NOT NULL DEFAULT 0 
GO