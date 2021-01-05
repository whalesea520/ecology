


ALTER table workflow_requestUserdefault ADD 
	numperpage int null,
	hascreatetime char(1) null,
	hascreater char(1) null,
	hasworkflowname char(1) null,
	hasrequestlevel char(1) null,
	hasrequestname char(1) null,
	hasreceivetime char(1) null,
	hasstatus char(1) null,
	hasreceivedpersons char(1) null
GO

ALTER PROCEDURE workflow_RUserDefault_Update 
@userid	int, 
@selectedworkflow text, 
@isuserdefault    char(1), 
@hascreatetime char(1) ,
@hascreater char(1) ,
@hasworkflowname char(1) ,
@hasrequestlevel char(1) ,
@hasrequestname char(1) ,
@hasreceivetime char(1) ,
@hasstatus char(1) ,
@hasreceivedpersons char(1) ,
@numperpage int ,
@flag integer output , 
@msg varchar(80) output 
AS 
Update workflow_requestUserdefault set 
selectedworkflow=@selectedworkflow ,
isuserdefault=@isuserdefault ,
hascreatetime=@hascreatetime ,
hascreater=@hascreater ,
hasworkflowname=@hasworkflowname ,
hasrequestlevel=@hasrequestlevel ,
hasrequestname=@hasrequestname ,
hasreceivetime=@hasreceivetime ,
hasstatus=@hasstatus ,
hasreceivedpersons=@hasreceivedpersons ,
numperpage=@numperpage 
where userid=@userid 

GO


ALTER PROCEDURE workflow_RUserDefault_Insert 
@userid	int, 
@selectedworkflow text, 
@isuserdefault    char(1), 
@hascreatetime char(1) ,
@hascreater char(1) ,
@hasworkflowname char(1) ,
@hasrequestlevel char(1) ,
@hasrequestname char(1) ,
@hasreceivetime char(1) ,
@hasstatus char(1) ,
@hasreceivedpersons char(1) ,
@numperpage int ,
@flag integer output , 
@msg varchar(80) output 
AS 
insert into workflow_requestUserdefault 
values(@userid ,@selectedworkflow ,@isuserdefault ,@hascreatetime ,@hascreater ,@hasworkflowname ,@hasrequestlevel ,@hasrequestname ,@hasreceivetime ,@hasstatus ,@hasreceivedpersons ,@numperpage) 

GO



INSERT INTO HtmlLabelIndex values(18256,'Ìõ') 
GO
INSERT INTO HtmlLabelInfo VALUES(18256,'Ìõ',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18256,'row',8) 
GO

update workflow_RequestUserDefault 
set hascreatetime ='1',hascreater ='1',hasworkflowname ='1',hasrequestlevel ='1',hasrequestname ='1',hasreceivetime ='1',hasstatus ='1',hasreceivedpersons ='0',numperpage =10
GO