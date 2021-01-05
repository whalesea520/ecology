alter table workflow_nodecustomrcmenu add subbackCtrl int 
GO
alter table workflow_nodecustomrcmenu add forhandbackCtrl int 
GO
alter table workflow_nodecustomrcmenu add forsubbackCtrl int 
GO
alter table workflow_nodecustomrcmenu add ccsubbackCtrl int 
GO
alter table workflow_nodecustomrcmenu add takingOpinionsbackCtrl int 
GO

alter table workflow_nodecustomrcmenu add isSubmitDirect char(1)
GO
alter table workflow_nodecustomrcmenu add submitDirectName7 varchar(4000)
GO
alter table workflow_nodecustomrcmenu add submitDirectName8 varchar(4000)
GO
alter table workflow_nodecustomrcmenu add submitDirectName9 varchar(4000)
GO

update workflow_nodecustomrcmenu set isshowinwflog=1, subbackCtrl=0, forhandbackCtrl=0, forsubbackCtrl=0, ccsubbackCtrl=0, takingOpinionsbackCtrl=0
GO
update workflow_nodecustomrcmenu set subbackCtrl = (case when (hasnoback = '1' and hasback = '1') then 2 when (hasnoback = '1' and (hasback != '1' or hasback is null)) then 1 else 0 end)
GO
update workflow_nodecustomrcmenu set forhandbackCtrl = (case when (hasforhandnoback = '1' and hasforhandback = '1') then 2 when (hasforhandnoback = '1' and (hasforhandback != '1' or hasforhandback is null)) then 1 else 0 end)
GO
update workflow_nodecustomrcmenu set forsubbackCtrl = (case when (hasfornoback = '1' and hasforback = '1') then 2 when (hasfornoback = '1' and (hasforback != '1' or hasforback is null)) then 1 else 0 end)
GO
update workflow_nodecustomrcmenu set ccsubbackCtrl = (case when (hasccnoback = '1' and hasccback = '1') then 2 when (hasccnoback = '1' and (hasccback != '1' or hasccback is null)) then 1 else 0 end)
GO
update workflow_nodecustomrcmenu set takingOpinionsbackCtrl = (case when (hastakingOpinionsnoback = '1' and hastakingOpinionsback = '1') then 2 when (hastakingOpinionsnoback = '1' and (hastakingOpinionsback != '1' or hastakingOpinionsback is null)) then 1 else 0 end)
GO

update workflow_nodecustomrcmenu set submitName7 = (case when (subbackName7 != '' and subbackName7 is not null) then subbackName7 else submitName7 end), submitName8 = (case when (subbackName8 != '' and subbackName8 is not null) then subbackName8 else submitName8 end), submitName9 = (case when (subbackName9 != '' and subbackName9 is not null) then subbackName9 else submitName9 end) where hasback = '1'
GO
update workflow_nodecustomrcmenu set subbackName7 = (case when (submitName7 != '' and submitName7 is not null) then submitName7 else subbackName7 end), subbackName8 = (case when (submitName8 != '' and submitName8 is not null) then submitName8 else subbackName8 end), subbackName9 = (case when (submitName9 != '' and submitName9 is not null) then submitName9 else subbackName9 end) where (hasback != '1' or hasback is null)
GO
update workflow_nodecustomrcmenu set forhandName7 = (case when (forhandbackName7 != '' and forhandbackName7 is not null) then forhandbackName7 else forhandName7 end), forhandName8 = (case when (forhandbackName8 != '' and forhandbackName8 is not null) then forhandbackName8 else forhandName8 end), forhandName9 = (case when (forhandbackName9 != '' and forhandbackName9 is not null) then forhandbackName9 else forhandName9 end) where hasforhandback = '1'
GO
update workflow_nodecustomrcmenu set forhandbackName7 = (case when (forhandName7 != '' and forhandName7 is not null) then forhandName7 else forhandbackName7 end), forhandbackName8 = (case when (forhandName8 != '' and forhandName8 is not null) then forhandName8 else forhandbackName8 end), forhandbackName9 = (case when (forhandName9 != '' and forhandName9 is not null) then forhandName9 else forhandbackName9 end) where (hasforhandback != '1' or hasforhandback is null)
GO
update workflow_nodecustomrcmenu set forsubName7 = (case when (forsubbackName7 != '' and forsubbackName7 is not null) then forsubbackName7 else forsubName7 end), forsubName8 = (case when (forsubbackName8 != '' and forsubbackName8 is not null) then forsubbackName8 else forsubName8 end), forsubName9 = (case when (forsubbackName9 != '' and forsubbackName9 is not null) then forsubbackName9 else forsubName9 end) where hasforback = '1'
GO
update workflow_nodecustomrcmenu set forsubbackName7 = (case when (forsubName7 != '' and forsubName7 is not null) then forsubName7 else forsubbackName7 end), forsubbackName8 = (case when (forsubName8 != '' and forsubName8 is not null) then forsubName8 else forsubbackName8 end), forsubbackName9 = (case when (forsubName9 != '' and forsubName9 is not null) then forsubName9 else forsubbackName9 end) where (hasforback != '1' or hasforback is null)
GO
update workflow_nodecustomrcmenu set ccsubName7 = (case when (ccsubbackName7 != '' and ccsubbackName7 is not null) then ccsubbackName7 else ccsubName7 end), ccsubName8 = (case when (ccsubbackName8 != '' and ccsubbackName8 is not null) then ccsubbackName8 else ccsubName8 end), ccsubName9 = (case when (ccsubbackName9 != '' and ccsubbackName9 is not null) then ccsubbackName9 else ccsubName9 end) where hasccback = '1'
GO
update workflow_nodecustomrcmenu set ccsubbackName7 = (case when (ccsubName7 != '' and ccsubName7 is not null) then ccsubName7 else ccsubbackName7 end), ccsubbackName8 = (case when (ccsubName8 != '' and ccsubName8 is not null) then ccsubName8 else ccsubbackName8 end), ccsubbackName9 = (case when (ccsubName9 != '' and ccsubName9 is not null) then ccsubName9 else ccsubbackName9 end) where (hasccback != '1' or hasccback is null)
GO
update workflow_nodecustomrcmenu set takingOpinionsName7 = (case when (takingOpinionsbackName7 != '' and takingOpinionsbackName7 is not null) then takingOpinionsbackName7 else takingOpinionsName7 end), takingOpinionsName8 = (case when (takingOpinionsbackName8 != '' and takingOpinionsbackName8 is not null) then takingOpinionsbackName8 else takingOpinionsName8 end), takingOpinionsName9 = (case when (takingOpinionsbackName9 != '' and takingOpinionsbackName9 is not null) then takingOpinionsbackName9 else takingOpinionsName9 end) where hastakingOpinionsback = '1'
GO
update workflow_nodecustomrcmenu set takingOpinionsbackName7 = (case when (takingOpinionsName7 != '' and takingOpinionsName7 is not null) then takingOpinionsName7 else takingOpinionsbackName7 end), takingOpinionsbackName8 = (case when (takingOpinionsName8 != '' and takingOpinionsName8 is not null) then takingOpinionsName8 else takingOpinionsbackName8 end), takingOpinionsbackName9 = (case when (takingOpinionsName9 != '' and takingOpinionsName9 is not null) then takingOpinionsName9 else takingOpinionsbackName9 end) where (hastakingOpinionsback != '1' or hastakingOpinionsback is null)
GO

alter table workflow_flownode add isRejectRemind char(1) 
GO
alter table workflow_flownode add isChangRejectNode char(1)
GO
alter table workflow_flownode add isSelectRejectNode int
GO
alter table workflow_flownode add rejectableNodes text
GO
alter table workflow_flownode add isSubmitDirectNode char(1)
GO

update workflow_flownode set isRejectRemind='0', isChangRejectNode='0', isSelectRejectNode=0
GO
update workflow_flownode set isRejectRemind='1' where workflowid in(select id from workflow_base where isRejectRemind='1')
GO
update workflow_flownode set isChangRejectNode='1' where workflowid in(select id from workflow_base where isRejectRemind='1' and isChangRejectNode='1')
GO
update workflow_flownode set isSelectRejectNode=1 where workflowid in(select id from workflow_base where isSelectRejectNode='1')
GO

CREATE TABLE workflow_nodeCustomNewMenu(
	id int IDENTITY(1,1) NOT NULL,
	wfid int not NULL,
	nodeid int not NULL,
	menuType int null,
	enable int null,
	newName7 varchar(4000) NULL,
	newName8 varchar(4000) NULL,
	newName9 varchar(4000) NULL,
	workflowid int null,
	customMessage varchar(4000) NULL,
	fieldid int null,
	usecustomsender char(1) null
)
GO

create procedure WFNodeCustomNewMenu_init AS
Declare 
	@wfid int,
	@nodeid int,
	@haswfrm char(1),
	@hassmsrm char(1),
	@haschats char(1),
	@newWFName7 varchar(4000),
	@newWFName8 varchar(4000),
	@newWFName9 varchar(4000),
	@newSMSName7 varchar(4000),
	@newSMSName8 varchar(4000),
	@newSMSName9 varchar(4000),
	@newCHATSName7 varchar(4000),
	@newCHATSName8 varchar(4000),
	@newCHATSName9 varchar(4000),
	@workflowid int,
	@customMessage varchar(4000),
	@fieldid int,
	@usecustomsender char(1),
	@customChats varchar(4000),
	@chatsfieldid int,
	@detail_cursor cursor
	delete from workflow_nodeCustomNewMenu
	SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR				
	select wfid,nodeid,haswfrm,hassmsrm,haschats,newWFName7,newWFName8,newWFName9,newSMSName7,newSMSName8,newSMSName9,newCHATSName7,newCHATSName8,newCHATSName9,workflowid,customMessage,fieldid,usecustomsender,customChats,chatsfieldid from workflow_nodecustomrcmenu where haswfrm='1' or hassmsrm='1' or haschats='1' order by wfid,nodeid,id
	OPEN @detail_cursor 
	fetch next from @detail_cursor INTO @wfid,@nodeid,@haswfrm,@hassmsrm,@haschats,@newWFName7,@newWFName8,@newWFName9,@newSMSName7,@newSMSName8,@newSMSName9,@newCHATSName7,@newCHATSName8,@newCHATSName9,@workflowid,@customMessage,@fieldid,@usecustomsender,@customChats,@chatsfieldid
	while @@FETCH_STATUS = 0 
	begin 
		if @haswfrm='1'
	    begin
			insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, workflowid) values(@wfid, @nodeid, 0, 1, @newWFName7, @newWFName8, @newWFName9, @workflowid)
		end
	    if @hassmsrm='1'
	    begin
			insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, customMessage, fieldid, usecustomsender) values(@wfid, @nodeid, 1, 1, @newSMSName7, @newSMSName8, @newSMSName9, @customMessage, @fieldid, @usecustomsender)
	    end
		if @haschats='1'
	    begin
			insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, customMessage, fieldid) values(@wfid, @nodeid, 2, 1, @newSMSName7, @newSMSName8, @newSMSName9, @customChats, @chatsfieldid)
	    end
		FETCH NEXT FROM @detail_cursor INTO @wfid,@nodeid,@haswfrm,@hassmsrm,@haschats,@newWFName7,@newWFName8,@newWFName9,@newSMSName7,@newSMSName8,@newSMSName9,@newCHATSName7,@newCHATSName8,@newCHATSName9,@workflowid,@customMessage,@fieldid,@usecustomsender,@customChats,@chatsfieldid
	end 
	CLOSE @detail_cursor 
	DEALLOCATE @detail_cursor
GO
exec WFNodeCustomNewMenu_init
GO

