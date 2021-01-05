alter table workflow_RequestUserDefault
add hascurrentnode char(1)
go

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
@hascurrentnode char(1) ,
@numperpage int ,
@flag integer output , 
@msg varchar(80) output 
AS 
insert into workflow_requestUserdefault 
values(@userid ,@selectedworkflow ,@isuserdefault ,@hascreatetime ,@hascreater ,@hasworkflowname ,@hasrequestlevel ,@hasrequestname ,@hasreceivetime ,@hasstatus ,@hasreceivedpersons ,@numperpage,@hascurrentnode) 

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
@hascurrentnode char(1) ,
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
hascurrentnode=@hascurrentnode ,
numperpage=@numperpage 
where userid=@userid 

GO


