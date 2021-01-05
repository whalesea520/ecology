alter table workflow_base add chatsType integer  
/
alter table workflow_base add chatsAlertType   integer  
/
alter table workflow_base add notRemindifArchived  integer  
/
alter table workflow_nodecustomrcmenu add haschats char(1)    
/
alter table workflow_nodecustomrcmenu add chatsfieldid  integer
/
alter table workflow_nodecustomrcmenu add newCHATSName7  varchar2(50)  
/
alter table workflow_nodecustomrcmenu add newCHATSName8  varchar2(50)  
/
alter table workflow_nodecustomrcmenu add newCHATSName9  varchar2(50)  
/
alter table workflow_nodecustomrcmenu add customChats  varchar2(200)  
/
alter table workflow_requestbase   add chatsType integer  
/ 
alter table workflow_nodelink   add ChatsRemind char(1) 
/
insert into wechat_reminder_mode values('workflow','流程模块')
/
insert into wechat_reminder_type values('wf_reject','流程退回','workflow')
/
insert into wechat_reminder_type values('wf_approve','流程审批','workflow')
/
insert into wechat_reminder_type values('wf_submit','流程确认','workflow')
/
insert into wechat_reminder_type values('wf_archive','流程归档','workflow')
/
insert into wechat_reminder_type values('wf_notice','流程抄送','workflow')
/
insert into wechat_reminder_set(prefix, prefixconnector, suffix, suffixconnector, type, def)  values('退回提醒:','','被退回，请您了解','','wf_reject','1')
/
insert into wechat_reminder_set(prefix, prefixconnector, suffix, suffixconnector, type, def) values('审批提醒:您有新的工作流需要审批:','','','','wf_approve','0')
/
insert into wechat_reminder_set(prefix, prefixconnector, suffix, suffixconnector, type, def) values('确认提醒:','','需要您的确认，请查阅','','wf_submit','0')
/
insert into wechat_reminder_set(prefix, prefixconnector, suffix, suffixconnector, type, def) values('归档提醒:','','已归档，请查阅','','wf_archive','0')
/
insert into wechat_reminder_set(prefix, prefixconnector, suffix, suffixconnector, type, def) values('抄送提醒:','','抄送给您，请查阅','','wf_notice','0')
/
update  workflow_base set chatsType ='0'  where chatsType  is null
/
CREATE OR REPLACE PROCEDURE workflow_Requestbase_InsertNew(requestid_1         integer,
                                                        workflowid_2        integer,
                                                        lastnodeid_3        integer,
                                                        lastnodetype_4      char,
                                                        currentnodeid_5     integer,
                                                        currentnodetype_6   char,
                                                        status_7            varchar2,
                                                        passedgroups_8      integer,
                                                        totalgroups_9       integer,
                                                        requestname_10      varchar2,
                                                        creater_11          integer,
                                                        createdate_12       char,
                                                        createtime_13       char,
                                                        lastoperator_14     integer,
                                                        lastoperatedate_15  char,
                                                        lastoperatetime_16  char,
                                                        deleted_17          integer,
                                                        creatertype_18      integer,
                                                        lastoperatortype_19 integer,
                                                        nodepasstime_20     float,
                                                        nodelefttime_21     float,
                                                        docids_22           Varchar2,
                                                        crmids_23           Varchar2,
                                                        hrmids_24           Varchar2,
                                                        prjids_25           Varchar2,
                                                        cptids_26           Varchar2,
                                                        messageType_27      integer,
                                                        chatsType_28        integer,
                                                        flag                out integer,
                                                        msg                 out varchar2,
                                                        thecursor           IN OUT cursor_define.weavercursor) AS
  currentdate char(10);
  currenttime char(8);
begin
  select to_char(sysdate, 'yyyy-mm-dd') into currentdate from dual;
  select to_char(sysdate, 'hh24:mi:ss') into currenttime from dual;
  insert into workflow_requestbase
    (requestid,
     workflowid,
     lastnodeid,
     lastnodetype,
     currentnodeid,
     currentnodetype,
     status,
     passedgroups,
     totalgroups,
     requestname,
     creater,
     createdate,
     createtime,
     lastoperator,
     lastoperatedate,
     lastoperatetime,
     deleted,
     creatertype,
     lastoperatortype,
     nodepasstime,
     nodelefttime,
     docids,
     crmids,
     hrmids,
     prjids,
     cptids,
     messageType,
     chatsType)
  values
    (requestid_1,
     workflowid_2,
     lastnodeid_3,
     lastnodetype_4,
     currentnodeid_5,
     currentnodetype_6,
     status_7,
     passedgroups_8,
     totalgroups_9,
     requestname_10,
     creater_11,
     currentdate,
     currenttime,
     lastoperator_14,
     lastoperatedate_15,
     lastoperatetime_16,
     deleted_17,
     creatertype_18,
     lastoperatortype_19,
     nodepasstime_20,
     nodelefttime_21,
     docids_22,
     crmids_23,
     hrmids_24,
     prjids_25,
     cptids_26,
     messageType_27,
     chatsType_28);
end;
/

CREATE OR REPLACE PROCEDURE workflow_Requestbase_Insert(requestid_1         integer,
                                                        workflowid_2        integer,
                                                        lastnodeid_3        integer,
                                                        lastnodetype_4      char,
                                                        currentnodeid_5     integer,
                                                        currentnodetype_6   char,
                                                        status_7            varchar2,
                                                        passedgroups_8      integer,
                                                        totalgroups_9       integer,
                                                        requestname_10      varchar2,
                                                        creater_11          integer,
                                                        createdate_12       char,
                                                        createtime_13       char,
                                                        lastoperator_14     integer,
                                                        lastoperatedate_15  char,
                                                        lastoperatetime_16  char,
                                                        deleted_17          integer,
                                                        creatertype_18      integer,
                                                        lastoperatortype_19 integer,
                                                        nodepasstime_20     float,
                                                        nodelefttime_21     float,
                                                        docids_22           Varchar2,
                                                        crmids_23           Varchar2,
                                                        hrmids_24           Varchar2,
                                                        prjids_25           Varchar2,
                                                        cptids_26           Varchar2,
                                                        messageType_27      integer,
                                                        flag                out integer,
                                                        msg                 out varchar2,
                                                        thecursor           IN OUT cursor_define.weavercursor) AS
  currentdate char(10);
  currenttime char(8);
begin

  workflow_Requestbase_InsertNew (
                                 
                                 requestid_1,
                                 workflowid_2,
                                 lastnodeid_3,
                                 lastnodetype_4,
                                 currentnodeid_5,
                                 currentnodetype_6,
                                 status_7,
                                 passedgroups_8,
                                 totalgroups_9,
                                 requestname_10,
                                 creater_11,
                                 createdate_12,
                                 createtime_13,
                                 lastoperator_14,
                                 lastoperatedate_15,
                                 lastoperatetime_16,
                                 deleted_17,
                                 creatertype_18,
                                 lastoperatortype_19,
                                 nodepasstime_20,
                                 nodelefttime_21,
                                 docids_22,
                                 crmids_23,
                                 hrmids_24,
                                 prjids_25,
                                 cptids_26,
                                 messageType_27,
				 null,
                                 flag,
                                 msg,
                                 thecursor);
end;
/
