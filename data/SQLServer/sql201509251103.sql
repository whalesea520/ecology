alter table workflow_currentoperator add lastRemindDatetime text
go

CREATE TABLE workflow_nodelinkOverTime(
	id int IDENTITY(1,1) NOT NULL,
	linkid int NULL,
	workflowid int NULL,
	remindname varchar(4000) NULL,
	remindtype int NULL,
	remindhour int NULL,
	remindminute int NULL,
	repeatremind int NULL,
	repeathour int NULL,
	repeatminute int NULL,
	FlowRemind char(1) NULL,
	MsgRemind char(1) NULL,
	MailRemind char(1) NULL,
	ChatsRemind char(1) NULL,
	InfoCentreRemind char(1) NULL,
	CustomWorkflowid int NULL,
	isnodeoperator char(1) NULL,
	iscreater char(1) NULL,
	ismanager char(1) NULL,
	isother char(1) NULL,
	remindobjectids text NULL
)
GO

create procedure WFNodeLinkToOverTime AS
Declare 
	@linkid int,
	@workflowid int,
	@isremind char(1),
	@isremind_csh char(1),
	@remindhour int,
	@remindhour_csh int,
	@remindminute int,
	@remindminute_csh int,
	@FlowRemind char(1),
	@FlowRemind_csh char(1),
	@MsgRemind char(1),
	@MsgRemind_csh char(1),
	@MailRemind char(1),
	@MailRemind_csh char(1),
	@ChatsRemind char(1),
	@ChatsRemind_csh char(1),
	@InfoCentreRemind char(1),
	@InfoCentreRemind_csh char(1),
	@CustomWorkflowid int,
	@CustomWorkflowid_csh int,
	@isnodeoperator char(1),
	@isnodeoperator_csh char(1),
	@iscreater char(1),
	@iscreater_csh char(1),
	@ismanager char(1),
	@ismanager_csh char(1),
	@isother char(1),
	@isother_csh char(1),
	@remindobjectids varchar(1000),
	@remindobjectids_csh varchar(1000),
	@remindname varchar(4000),
	@detail_cursor cursor
	delete from workflow_nodelinkOverTime
	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
	select a.id,a.workflowid,a.isremind,a.isremind_csh,a.remindhour,a.remindhour_csh,a.remindminute,a.remindminute_csh,a.FlowRemind,a.FlowRemind_csh,a.MsgRemind,a.MsgRemind_csh,a.MailRemind,a.MailRemind_csh,a.ChatsRemind,a.ChatsRemind_csh,a.InfoCentreRemind,a.InfoCentreRemind_csh,a.CustomWorkflowid,a.CustomWorkflowid_csh,a.isnodeoperator,a.isnodeoperator_csh,a.iscreater,a.iscreater_csh,a.ismanager,a.ismanager_csh,a.isother,a.isother_csh,a.remindobjectids,a.remindobjectids_csh from workflow_nodelink a, workflow_flownode b where a.workflowid = b.workflowid and a.nodeid = b.nodeid and b.nodetype != '0' and (a.isreject != '1' or a.isreject is null) and (a.isremind = '1' or a.isremind_csh = '1')
	OPEN @detail_cursor 
	fetch next from @detail_cursor INTO @linkid,@workflowid,@isremind,@isremind_csh,@remindhour,@remindhour_csh,@remindminute,@remindminute_csh,@FlowRemind,@FlowRemind_csh,@MsgRemind,@MsgRemind_csh,@MailRemind,@MailRemind_csh,@ChatsRemind,@ChatsRemind_csh,@InfoCentreRemind,@InfoCentreRemind_csh,@CustomWorkflowid,@CustomWorkflowid_csh,@isnodeoperator,@isnodeoperator_csh,@iscreater,@iscreater_csh,@ismanager,@ismanager_csh,@isother,@isother_csh,@remindobjectids,@remindobjectids_csh
	while @@FETCH_STATUS = 0 
	begin 
		if @isremind='1'
	    begin
			set @remindname = '提醒1'
			insert into workflow_nodelinkOverTime (linkid, workflowid, remindname, remindtype, remindhour, remindminute, repeatremind, repeathour, repeatminute, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids)
			values(@linkid, @workflowid, @remindname, 0, @remindhour, @remindminute, 0, 0, 0, @FlowRemind, @MsgRemind, @MailRemind, @ChatsRemind, @InfoCentreRemind, @CustomWorkflowid, @isnodeoperator, @iscreater, @ismanager, @isother, @remindobjectids)
		end
	    if @isremind_csh='1'
	    begin
			if @remindname = '提醒1'
			begin
				set @remindname = '提醒2'
			end
			else
			begin 
				set @remindname = '提醒1'
			end
			insert into workflow_nodelinkOverTime (linkid, workflowid, remindname, remindtype, remindhour, remindminute, repeatremind, repeathour, repeatminute, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids)
			values(@linkid, @workflowid, @remindname, 1, @remindhour_csh, @remindminute_csh, 0, 0, 0, @FlowRemind_csh, @MsgRemind_csh, @MailRemind_csh, @ChatsRemind_csh, @InfoCentreRemind_csh, @CustomWorkflowid_csh, @isnodeoperator_csh, @iscreater_csh, @ismanager_csh, @isother_csh, @remindobjectids_csh)
	    end
		FETCH NEXT FROM @detail_cursor INTO @linkid,@workflowid,@isremind,@isremind_csh,@remindhour,@remindhour_csh,@remindminute,@remindminute_csh,@FlowRemind,@FlowRemind_csh,@MsgRemind,@MsgRemind_csh,@MailRemind,@MailRemind_csh,@ChatsRemind,@ChatsRemind_csh,@InfoCentreRemind,@InfoCentreRemind_csh,@CustomWorkflowid,@CustomWorkflowid_csh,@isnodeoperator,@isnodeoperator_csh,@iscreater,@iscreater_csh,@ismanager,@ismanager_csh,@isother,@isother_csh,@remindobjectids,@remindobjectids_csh
	end 
	CLOSE @detail_cursor 
	DEALLOCATE @detail_cursor
GO
exec WFNodeLinkToOverTime
go




