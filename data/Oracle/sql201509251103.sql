alter table workflow_currentoperator add lastRemindDatetime varchar2(4000)
/

CREATE TABLE workflow_nodelinkOverTime(
	id integer NOT NULL,
	linkid integer NULL,
	workflowid integer NULL,
	remindname varchar2(4000) NULL,
	remindtype integer NULL,
	remindhour integer NULL,
	remindminute integer NULL,
	repeatremind integer NULL,
	repeathour integer  NULL,
	repeatminute integer  NULL,
	FlowRemind char(1) NULL,
	MsgRemind char(1) NULL,
	MailRemind char(1) NULL,
	ChatsRemind char(1) NULL,
	InfoCentreRemind char(1) NULL,
	CustomWorkflowid integer  NULL,
	isnodeoperator char(1) NULL,
	iscreater char(1) NULL,
	ismanager char(1) NULL,
	isother char(1) NULL,
	remindobjectids varchar2(4000) NULL
)
/
create sequence workflow_nodelinkOverTime_id
start with 1                                               
increment by 1                                             
nomaxvalue                                                 
nocycle
/
create or replace trigger workflow_nodelinkOverTime_Tri
before insert on workflow_nodelinkOverTime
for each row                                               
begin                                                      
select workflow_nodelinkOverTime_id.nextval INTO :new.id from dual;
end;  
/

CREATE OR REPLACE PROCEDURE WFNodeLinkToOverTime 
AS
	linkid int;
	workflowid int;
	isremind char(1);
	isremind_csh char(1);
	remindhour int;
	remindhour_csh int;
	remindminute int;
	remindminute_csh int;
	FlowRemind char(1);
  FlowRemind_csh char(1);
  MsgRemind char(1);
  MsgRemind_csh char(1);
  MailRemind char(1);
  MailRemind_csh char(1);
  ChatsRemind char(1);
  ChatsRemind_csh char(1);
  InfoCentreRemind char(1);
  InfoCentreRemind_csh char(1);
  CustomWorkflowid int;
  CustomWorkflowid_csh int;
  isnodeoperator char(1);
  isnodeoperator_csh char(1);
  iscreater char(1);
  iscreater_csh char(1);
  ismanager char(1);
  ismanager_csh char(1);
  isother char(1);
  isother_csh char(1);
  remindobjectids varchar2(1000);
  remindobjectids_csh varchar2(1000);
	remindname varchar2(4000);
begin  
	delete from workflow_nodelinkOverTime;
	
	for all_cursor IN (select a.id,a.workflowid,a.isremind,a.isremind_csh,a.remindhour,a.remindhour_csh,a.remindminute,a.remindminute_csh,a.FlowRemind,a.FlowRemind_csh,a.MsgRemind,a.MsgRemind_csh,a.MailRemind,a.MailRemind_csh,a.ChatsRemind,a.ChatsRemind_csh,a.InfoCentreRemind,a.InfoCentreRemind_csh,a.CustomWorkflowid,a.CustomWorkflowid_csh,a.isnodeoperator,a.isnodeoperator_csh,a.iscreater,a.iscreater_csh,a.ismanager,a.ismanager_csh,a.isother,a.isother_csh,a.remindobjectids,a.remindobjectids_csh from workflow_nodelink a, workflow_flownode b where a.workflowid = b.workflowid and a.nodeid = b.nodeid and b.nodetype != '0' and (a.isreject != '1' or a.isreject is null) and (a.isremind = '1' or a.isremind_csh = '1'))
  	loop     
      linkid := all_cursor.id;
      workflowid := all_cursor.workflowid;
      isremind := all_cursor.isremind;
      isremind_csh := all_cursor.isremind_csh;
      remindhour := all_cursor.remindhour;
      remindhour_csh := all_cursor.remindhour_csh;
      remindminute := all_cursor.remindminute;
      remindminute_csh := all_cursor.remindminute_csh;
      FlowRemind := all_cursor.FlowRemind;
      FlowRemind_csh := all_cursor.FlowRemind_csh;
      MsgRemind := all_cursor.MsgRemind;
      MsgRemind_csh := all_cursor.MsgRemind_csh;
      MailRemind := all_cursor.MailRemind;
      MailRemind_csh := all_cursor.MailRemind_csh;
      ChatsRemind := all_cursor.ChatsRemind;
      ChatsRemind_csh := all_cursor.ChatsRemind_csh;
      InfoCentreRemind := all_cursor.InfoCentreRemind;
      InfoCentreRemind_csh := all_cursor.InfoCentreRemind_csh;
      CustomWorkflowid := all_cursor.CustomWorkflowid;
      CustomWorkflowid_csh := all_cursor.CustomWorkflowid_csh;
      isnodeoperator := all_cursor.isnodeoperator;
      isnodeoperator_csh := all_cursor.isnodeoperator_csh;
      iscreater := all_cursor.iscreater;
      iscreater_csh := all_cursor.iscreater_csh;
      ismanager := all_cursor.ismanager;
      ismanager_csh := all_cursor.ismanager_csh;
      isother := all_cursor.isother;
      isother_csh := all_cursor.isother_csh;
      remindobjectids := all_cursor.remindobjectids;
      remindobjectids_csh := all_cursor.remindobjectids_csh;
      
      if (isremind='1') then
        remindname := '提醒1';
        insert into workflow_nodelinkOverTime (linkid, workflowid, remindname, remindtype, remindhour, remindminute, repeatremind, repeathour, repeatminute, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids)
			  values(linkid, workflowid, remindname, 0, remindhour, remindminute, 0, 0, 0, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids);
      end if;
      
      if (isremind_csh='1') then 
       IF (remindname = '提醒1') THEN 
         remindname := '提醒2';
       else
         remindname := '提醒1';
       end if;
       insert into workflow_nodelinkOverTime (linkid, workflowid, remindname, remindtype, remindhour, remindminute, repeatremind, repeathour, repeatminute, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids)
			 values(linkid, workflowid, remindname, 1, remindhour_csh, remindminute_csh, 0, 0, 0, FlowRemind_csh, MsgRemind_csh, MailRemind_csh, ChatsRemind_csh, InfoCentreRemind_csh, CustomWorkflowid_csh, isnodeoperator_csh, iscreater_csh, ismanager_csh, isother_csh, remindobjectids_csh);
      end if;
      
  end loop;
  COMMIT;
 end;
/
call WFNodeLinkToOverTime()
/


