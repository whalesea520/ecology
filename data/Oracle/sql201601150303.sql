alter table workflow_nodecustomrcmenu add subbackCtrl int 
/
alter table workflow_nodecustomrcmenu add forhandbackCtrl int 
/
alter table workflow_nodecustomrcmenu add forsubbackCtrl int 
/
alter table workflow_nodecustomrcmenu add ccsubbackCtrl int 
/
alter table workflow_nodecustomrcmenu add takingOpinionsbackCtrl int 
/

alter table workflow_nodecustomrcmenu add isSubmitDirect char(1)
/
alter table workflow_nodecustomrcmenu add submitDirectName7 varchar2(4000)
/
alter table workflow_nodecustomrcmenu add submitDirectName8 varchar2(4000)
/
alter table workflow_nodecustomrcmenu add submitDirectName9 varchar2(4000)
/

update workflow_nodecustomrcmenu set isshowinwflog=1, subbackCtrl=0, forhandbackCtrl=0, forsubbackCtrl=0, ccsubbackCtrl=0, takingOpinionsbackCtrl=0
/
update workflow_nodecustomrcmenu set subbackCtrl = (case when (hasnoback = '1' and hasback = '1') then 2 when (hasnoback = '1' and (hasback != '1' or hasback is null)) then 1 else 0 end)
/
update workflow_nodecustomrcmenu set forhandbackCtrl = (case when (hasforhandnoback = '1' and hasforhandback = '1') then 2 when (hasforhandnoback = '1' and (hasforhandback != '1' or hasforhandback is null)) then 1 else 0 end)
/
update workflow_nodecustomrcmenu set forsubbackCtrl = (case when (hasfornoback = '1' and hasforback = '1') then 2 when (hasfornoback = '1' and (hasforback != '1' or hasforback is null)) then 1 else 0 end)
/
update workflow_nodecustomrcmenu set ccsubbackCtrl = (case when (hasccnoback = '1' and hasccback = '1') then 2 when (hasccnoback = '1' and (hasccback != '1' or hasccback is null)) then 1 else 0 end)
/
update workflow_nodecustomrcmenu set takingOpinionsbackCtrl = (case when (hastakingOpinionsnoback = '1' and hastakingOpinionsback = '1') then 2 when (hastakingOpinionsnoback = '1' and (hastakingOpinionsback != '1' or hastakingOpinionsback is null)) then 1 else 0 end)
/

update workflow_nodecustomrcmenu set submitName7 = (case when (subbackName7 != '' or subbackName7 is not null) then subbackName7 else submitName7 end), submitName8 = (case when (subbackName8 != '' or subbackName8 is not null) then subbackName8 else submitName8 end), submitName9 = (case when (subbackName9 != '' or subbackName9 is not null) then subbackName9 else submitName9 end) where hasback = '1'
/
update workflow_nodecustomrcmenu set subbackName7 = (case when (submitName7 != '' or submitName7 is not null) then submitName7 else subbackName7 end), subbackName8 = (case when (submitName8 != '' or submitName8 is not null) then submitName8 else subbackName8 end), subbackName9 = (case when (submitName9 != '' or submitName9 is not null) then submitName9 else subbackName9 end) where (hasback != '1' or hasback is null)
/
update workflow_nodecustomrcmenu set forhandName7 = (case when (forhandbackName7 != '' or forhandbackName7 is not null) then forhandbackName7 else forhandName7 end), forhandName8 = (case when (forhandbackName8 != '' or forhandbackName8 is not null) then forhandbackName8 else forhandName8 end), forhandName9 = (case when (forhandbackName9 != '' or forhandbackName9 is not null) then forhandbackName9 else forhandName9 end) where hasforhandback = '1'
/
update workflow_nodecustomrcmenu set forhandbackName7 = (case when (forhandName7 != '' or forhandName7 is not null) then forhandName7 else forhandbackName7 end), forhandbackName8 = (case when (forhandName8 != '' or forhandName8 is not null) then forhandName8 else forhandbackName8 end), forhandbackName9 = (case when (forhandName9 != '' or forhandName9 is not null) then forhandName9 else forhandbackName9 end) where (hasforhandback != '1' or hasforhandback is null)
/
update workflow_nodecustomrcmenu set forsubName7 = (case when (forsubbackName7 != '' or forsubbackName7 is not null) then forsubbackName7 else forsubName7 end), forsubName8 = (case when (forsubbackName8 != '' or forsubbackName8 is not null) then forsubbackName8 else forsubName8 end), forsubName9 = (case when (forsubbackName9 != '' or forsubbackName9 is not null) then forsubbackName9 else forsubName9 end) where hasforback = '1'
/
update workflow_nodecustomrcmenu set forsubbackName7 = (case when (forsubName7 != '' or forsubName7 is not null) then forsubName7 else forsubbackName7 end), forsubbackName8 = (case when (forsubName8 != '' or forsubName8 is not null) then forsubName8 else forsubbackName8 end), forsubbackName9 = (case when (forsubName9 != '' or forsubName9 is not null) then forsubName9 else forsubbackName9 end) where (hasforback != '1' or hasforback is null)
/
update workflow_nodecustomrcmenu set ccsubName7 = (case when (ccsubbackName7 != '' or ccsubbackName7 is not null) then ccsubbackName7 else ccsubName7 end), ccsubName8 = (case when (ccsubbackName8 != '' or ccsubbackName8 is not null) then ccsubbackName8 else ccsubName8 end), ccsubName9 = (case when (ccsubbackName9 != '' or ccsubbackName9 is not null) then ccsubbackName9 else ccsubName9 end) where hasccback = '1'
/
update workflow_nodecustomrcmenu set ccsubbackName7 = (case when (ccsubName7 != '' or ccsubName7 is not null) then ccsubName7 else ccsubbackName7 end), ccsubbackName8 = (case when (ccsubName8 != '' or ccsubName8 is not null) then ccsubName8 else ccsubbackName8 end), ccsubbackName9 = (case when (ccsubName9 != '' or ccsubName9 is not null) then ccsubName9 else ccsubbackName9 end) where (hasccback != '1' or hasccback is null)
/
update workflow_nodecustomrcmenu set takingOpinionsName7 = (case when (takingOpinionsbackName7 != '' or takingOpinionsbackName7 is not null) then takingOpinionsbackName7 else takingOpinionsName7 end), takingOpinionsName8 = (case when (takingOpinionsbackName8 != '' or takingOpinionsbackName8 is not null) then takingOpinionsbackName8 else takingOpinionsName8 end), takingOpinionsName9 = (case when (takingOpinionsbackName9 != '' or takingOpinionsbackName9 is not null) then takingOpinionsbackName9 else takingOpinionsName9 end) where hastakingOpinionsback = '1'
/
update workflow_nodecustomrcmenu set takingOpinionsbackName7 = (case when (takingOpinionsName7 != '' or takingOpinionsName7 is not null) then takingOpinionsName7 else takingOpinionsbackName7 end), takingOpinionsbackName8 = (case when (takingOpinionsName8 != '' or takingOpinionsName8 is not null) then takingOpinionsName8 else takingOpinionsbackName8 end), takingOpinionsbackName9 = (case when (takingOpinionsName9 != '' or takingOpinionsName9 is not null) then takingOpinionsName9 else takingOpinionsbackName9 end) where (hastakingOpinionsback != '1' or hastakingOpinionsback is null)
/

alter table workflow_flownode add isRejectRemind char(1) 
/
alter table workflow_flownode add isChangRejectNode char(1)
/
alter table workflow_flownode add isSelectRejectNode integer
/
alter table workflow_flownode add rejectableNodes varchar2(4000)
/
alter table workflow_flownode add isSubmitDirectNode char(1)
/

update workflow_flownode set isRejectRemind='0', isChangRejectNode='0', isSelectRejectNode=0
/
update workflow_flownode set isRejectRemind='1' where workflowid in(select id from workflow_base where isRejectRemind='1')
/
update workflow_flownode set isChangRejectNode='1' where workflowid in(select id from workflow_base where isRejectRemind='1' and isChangRejectNode='1')
/
update workflow_flownode set isSelectRejectNode=1 where workflowid in(select id from workflow_base where isSelectRejectNode='1')
/

CREATE TABLE workflow_nodeCustomNewMenu(
	id integer NOT NULL,
	wfid integer not NULL,
	nodeid integer not NULL,
	menuType integer null,
	enable integer null,
	newName7 varchar2(4000) NULL,
	newName8 varchar2(4000) NULL,
	newName9 varchar2(4000) NULL,
	workflowid integer null,
	customMessage varchar2(4000) NULL,
	fieldid integer null,
	usecustomsender char(1) null
)
/
create sequence workflow_nodeCustomNewMenu_id
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger wf_nodeCustomNewMenu_Tri
before insert on workflow_nodeCustomNewMenu
for each row                                               
begin                                                      
select workflow_nodeCustomNewMenu_id.nextval INTO :new.id from dual;
end;  
/

CREATE OR REPLACE PROCEDURE WFNodeCustomNewMenu_init 
AS
	wfid int;
	nodeid int;
	haswfrm char(1);
	hassmsrm char(1);
	haschats char(1);
	newWFName7 varchar(4000);
	newWFName8 varchar(4000);
	newWFName9 varchar(4000);
	newSMSName7 varchar(4000);
	newSMSName8 varchar(4000);
	newSMSName9 varchar(4000);
	newCHATSName7 varchar(4000);
	newCHATSName8 varchar(4000);
	newCHATSName9 varchar(4000);
	workflowid int;
	customMessage varchar(4000);
	fieldid int;
	usecustomsender char(1);
	customChats varchar(4000);
	chatsfieldid int;
begin  
	delete from workflow_nodeCustomNewMenu;
	
	for all_cursor IN (select wfid,nodeid,haswfrm,hassmsrm,haschats,newWFName7,newWFName8,newWFName9,newSMSName7,newSMSName8,newSMSName9,newCHATSName7,newCHATSName8,newCHATSName9,workflowid,customMessage,fieldid,usecustomsender,customChats,chatsfieldid from workflow_nodecustomrcmenu where haswfrm='1' or hassmsrm='1' or haschats='1' order by wfid,nodeid,id)
  	loop     
      wfid := all_cursor.wfid;
      nodeid := all_cursor.nodeid;
      haswfrm := all_cursor.haswfrm;
      hassmsrm := all_cursor.hassmsrm;
      haschats := all_cursor.haschats;
      newWFName7 := all_cursor.newWFName7;
      newWFName8 := all_cursor.newWFName8;
      newWFName9 := all_cursor.newWFName9;
      newSMSName7 := all_cursor.newSMSName7;
      newSMSName8 := all_cursor.newSMSName8;
      newSMSName9 := all_cursor.newSMSName9;
      newCHATSName7 := all_cursor.newCHATSName7;
      newCHATSName8 := all_cursor.newCHATSName8;
      newCHATSName9 := all_cursor.newCHATSName9;
      workflowid := all_cursor.workflowid;
      customMessage := all_cursor.customMessage;
      fieldid := all_cursor.fieldid;
      usecustomsender := all_cursor.usecustomsender;
      customChats := all_cursor.customChats;
      chatsfieldid := all_cursor.chatsfieldid;
	  
      if (haswfrm='1') then
        insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, workflowid) values(wfid, nodeid, 0, 1, newWFName7, newWFName8, newWFName9, workflowid);
      end if;
      if (hassmsrm='1') then 
		insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, customMessage, fieldid, usecustomsender) values(wfid, nodeid, 1, 1, newSMSName7, newSMSName8, newSMSName9, customMessage, fieldid, usecustomsender);
      end if;
	  if (haschats='1') then 
		insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, customMessage, fieldid) values(wfid, nodeid, 2, 1, newCHATSName7, newCHATSName8, newCHATSName9, customChats, chatsfieldid);
      end if;
      
  end loop;
  COMMIT;
 end;
/
call WFNodeCustomNewMenu_init()
/

















