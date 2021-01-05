alter table workflow_requestUserdefault add  commonuse varchar(10)
GO
update workflow_requestUserdefault set  commonuse = 1
GO
alter table DocUserDefault add commonuse varchar(10)
GO
update DocUserDefault set commonuse=1
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
@hascurrentnode char(1) ,
@numperpage int ,
@noReceiveMailRemind char(1) ,
@Showoperator char(1) ,
@commonuse char(1) ,
@flag integer output , 
@msg varchar(80) output 
AS 
insert into workflow_requestUserdefault(userid,selectedworkflow,isuserdefault,hascreatetime,hascreater,hasworkflowname,hasrequestlevel,hasrequestname,hasreceivetime,hasstatus,hasreceivedpersons,numperpage,hascurrentnode,noReceiveMailRemind,Showoperator,commonuse) 
values(@userid ,@selectedworkflow ,@isuserdefault ,@hascreatetime ,@hascreater ,@hasworkflowname ,@hasrequestlevel ,@hasrequestname ,@hasreceivetime ,@hasstatus ,@hasreceivedpersons ,@numperpage,@hascurrentnode,@noReceiveMailRemind,@Showoperator,@commonuse) 
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
@noReceiveMailRemind char(1) ,
@Showoperator char(1) ,
@commonuse char(1) ,
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
numperpage=@numperpage ,
noReceiveMailRemind=@noReceiveMailRemind,
Showoperator=@Showoperator,
commonuse=@commonuse
where userid=@userid
GO