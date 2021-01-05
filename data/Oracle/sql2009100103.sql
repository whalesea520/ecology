alter table workflow_trackdetail add fieldNameTw varchar2(100) default null
/
alter table workflow_track add fieldNameTw varchar2(100) default null
/
alter table WFOpinionField add label_tw varchar2(100) default null
/
update syslanguage set language='简体中文' where language='中文'
/
insert into syslanguage values(9,'繁體中文','GBK',1)
/
alter table outrepmodule add moduletwname varchar2(100) default null
/
alter table T_OutReportCondition add conditiontwname varchar2(100) default null
/
alter table T_OutReport add twmodulefilename varchar2(100) default null
/
alter table T_OutReport add outreptwname varchar2(100) default null
/
alter table T_OutReport add outRepTwDesc varchar2(100) default null
/
alter table CRM_CustomerInfo add twname varchar2(100) default null
/
alter table T_OutReportItem add itemtwdesc varchar2(100) default null
/
alter table leftmenuinfo add customName_t varchar2(100) default null
/
alter table leftmenuconfig add customName_t varchar2(100) default null
/
alter table mainmenuinfo add customName_t varchar2(100) default null
/
alter table mainmenuconfig add customName_t varchar2(100) default null
/


alter TABLE workflow_nodecustomrcmenu add  submitName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  forwardName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  saveName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  rejectName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  forsubName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  ccsubName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  newWFName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  newSMSName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  subnobackName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  subbackName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  forsubnobackName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  forsubbackName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  ccsubnobackName9 varchar2(50)
/
alter TABLE workflow_nodecustomrcmenu add  ccsubbackName9 varchar2(50)
/

alter TABLE workflow_nodecustomrcmenu add  newOverTimeName9 varchar2(50)
/
