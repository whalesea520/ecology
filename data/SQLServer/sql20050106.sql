/*label数据*/
INSERT INTO HtmlLabelIndex values(17564,'流程代理菜单') 
GO
INSERT INTO HtmlLabelInfo VALUES(17564,'流程代理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17564,'WorkflowAgent',8) 
GO
INSERT INTO HtmlLabelIndex values(17565,'被代理人') 
GO
INSERT INTO HtmlLabelIndex values(17566,'代理人') 
GO
INSERT INTO HtmlLabelInfo VALUES(17565,'被代理人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17565,'beAgenter',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17566,'代理人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17566,'Agenter',8) 
GO
INSERT INTO HtmlLabelIndex values(17577,'代理流程创建') 
GO
INSERT INTO HtmlLabelInfo VALUES(17577,'代理流程创建',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17577,'creater agenter',8) 
GO

/*权限数据*/
delete from SystemRights where id=455
GO
insert into SystemRights (id,rightdesc,righttype) values (455,'流程代理公共权限','5') 
GO
delete from SystemRightsLanguage where id=455
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (455,7,'公共流程代理维护','设置所有人的流程代理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (455,8,'WrokflowAgentAll','set workflow agent info for all') 
GO
delete from SystemRightDetail where id=3146
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3146,'流程代理公共权限','WorkflowAgent:All',455) 
GO

delete from SystemRights where id=456
GO
insert into SystemRights (id,rightdesc,righttype) values (456,'流程代理个人权限','5') 
GO
delete from SystemRightsLanguage where id=456
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (456,7,'个人流程代理维护','设置所有人的流程代理') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (456,8,'WrokflowAgentSelf','set workflow agent info for self') 
GO
delete from SystemRightDetail where id=3147
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3147,'流程代理个人权限','WorkflowAgent:Self',456) 
GO

/*添加id分配数据*/
DELETE FROM SequenceIndex WHERE indexdesc='workflowagentid';
INSERT INTO SequenceIndex VALUES('workflowagentid',1);


/*创建表*/

CREATE TABLE Workflow_Agent 
(
    agentId         int             NOT NULL PRIMARY KEY,
    workflowId      int             NULL,
    beagenterId     int             NULL,
    agenterId       int             NULL,
    beginDate       char(10)        NULL,
    beginTime       char(8)         NULL,
    endDate         char(10)        NULL,
    endTime         char(8)         NULL,
    isCreateAgenter int             NULL
)
GO

/*修改workflow_createrlist表结构，记录创建权限来源*/
ALTER TABLE workflow_createrlist
ADD isAgenter int NULL
GO

DROP PROCEDURE workflow_createrlist_Insert 
GO
CREATE PROCEDURE workflow_createrlist_Insert 
(@workflowid_1  int,
 @userid_2  int,
 @usertype_3    int, 
 @usertype_4    int,        /* 当为所有人和所有客户的时候，为最大安全级别，否则为0 */
 @isagenter     int,        /* 记录创建权限来源*/
 @flag integer output , 
 @msg varchar(80) output )

AS INSERT INTO workflow_createrlist 
( workflowid, userid, usertype, usertype2, isAgenter ) 
 
VALUES 
( @workflowid_1, @userid_2, @usertype_3, @usertype_4, @isagenter )

GO