/*label数据*/
INSERT INTO HtmlLabelIndex values(17582,'是否短信提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17582,'是否短信提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17582,'is message remind',8) 
GO
INSERT INTO HtmlLabelIndex values(17583,'不短信提醒') 
GO
INSERT INTO HtmlLabelIndex values(17585,'在线短信提醒') 
GO
INSERT INTO HtmlLabelIndex values(17584,'离线短信提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17583,'不短信提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17583,'no message remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17584,'离线短信提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17584,'offline message remind',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17585,'在线短信提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17585,'online message remind',8) 
GO
INSERT INTO HtmlLabelIndex values(17586,'短信提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17586,'短信提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17586,'message remind',8) 
GO

/*修改workflow_base表结构，记录是否能够短信提醒*/
ALTER TABLE workflow_base
ADD messageType int NULL
GO

/*修改workflow_requestbase表结构，记录流程的短信提醒类型*/
ALTER TABLE workflow_requestbase
ADD messageType int NULL
GO


DROP PROCEDURE workflow_Requestbase_Insert 
GO
CREATE PROCEDURE workflow_Requestbase_Insert 
@requestid	int, @workflowid	int, @lastnodeid	int, 
@lastnodetype	char(1), @currentnodeid	int, @currentnodetype	char(1), 
@status		varchar(50), @passedgroups	int, @totalgroups	int, 
@requestname	varchar(255), @creater	int, @createdate	char(10), 
@createtime	char(8), @lastoperator	int, @lastoperatedate	char(10), 
@lastoperatetime	char(8), @deleted	int, @creatertype	int, 
@lastoperatortype	int, @nodepasstime	float, @nodelefttime	float, 
@docids 		[text], @crmids 		[text], 
@hrmids 		[text], @prjids 		[text], 
@cptids 		[text], @messageType 	int, 
@flag integer output , @msg varchar(80) output 
AS 
insert into workflow_requestbase 
(requestid,workflowid,lastnodeid,lastnodetype, currentnodeid,currentnodetype,status, 
passedgroups,totalgroups,requestname,creater,createdate,createtime,lastoperator, 
lastoperatedate,lastoperatetime,deleted,creatertype,lastoperatortype,nodepasstime,
nodelefttime,docids,crmids,hrmids,prjids,cptids,messageType) 
values
(@requestid,@workflowid,@lastnodeid,@lastnodetype, @currentnodeid,@currentnodetype,@status, 
@passedgroups,@totalgroups,@requestname,@creater,@createdate,@createtime,@lastoperator, 
@lastoperatedate,@lastoperatetime,@deleted,@creatertype,@lastoperatortype,@nodepasstime,
@nodelefttime,@docids,@crmids,@hrmids,@prjids,@cptids,@messageType)
GO



