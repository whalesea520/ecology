/*label数据*/
INSERT INTO HtmlLabelIndex values(17564,'流程代理菜单') 
/
INSERT INTO HtmlLabelInfo VALUES(17564,'流程代理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17564,'WorkflowAgent',8)
/
INSERT INTO HtmlLabelIndex values(17565,'被代理人') 
/
INSERT INTO HtmlLabelIndex values(17566,'代理人') 
/
INSERT INTO HtmlLabelInfo VALUES(17565,'被代理人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17565,'beAgenter',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17566,'代理人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17566,'Agenter',8) 
/
INSERT INTO HtmlLabelIndex values(17577,'代理流程创建') 
/
INSERT INTO HtmlLabelInfo VALUES(17577,'代理流程创建',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17577,'creater agenter',8) 
/

/*权限数据*/
insert into SystemRights (id,rightdesc,righttype) values (455,'流程代理公共权限','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (455,7,'公共流程代理维护','设置所有人的流程代理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (455,8,'WrokflowAgentAll','set workflow agent info for all') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3146,'流程代理公共权限','WorkflowAgent:All',455) 
/

insert into SystemRights (id,rightdesc,righttype) values (456,'流程代理个人权限','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (456,7,'个人流程代理维护','设置所有人的流程代理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (456,8,'WrokflowAgentSelf','set workflow agent info for self') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3147,'流程代理个人权限','WorkflowAgent:Self',456) 
/

/*添加id分配数据*/
INSERT INTO SequenceIndex VALUES('workflowagentid',1)
/


/*创建表*/

CREATE TABLE Workflow_Agent 
(
    agentId         integer             NOT NULL PRIMARY KEY,
    workflowId      integer             NULL,
    beagenterId     integer             NULL,
    agenterId       integer             NULL,
    beginDate       char(10)        NULL,
    beginTime       char(8)         NULL,
    endDate         char(10)        NULL,
    endTime         char(8)         NULL,
    isCreateAgenter integer             NULL
)
/

/*修改workflow_createrlist表结构，记录创建权限来源*/
ALTER TABLE workflow_createrlist ADD isAgenter integer NULL
/

DROP PROCEDURE workflow_createrlist_Insert 
/
CREATE OR REPLACE PROCEDURE workflow_createrlist_Insert 
(workflowid_1  integer,
 userid_2  integer,
 usertype_3    integer,
 usertype_4    integer,        /* 当为所有人和所有客户的时候，为最大安全级别，否则为0 */
 isagenter     integer,        /* 记录创建权限来源*/
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO workflow_createrlist 
(   workflowid,
    userid,
    usertype,
    usertype2,
    isAgenter )
 VALUES 
(   workflowid_1,
    userid_2,
    usertype_3,
    usertype_4,
    isagenter );
end;
/