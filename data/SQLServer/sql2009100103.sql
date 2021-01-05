alter table workflow_trackdetail add fieldNameTw varchar(100) default null
GO
alter table workflow_track add fieldNameTw varchar(100) default null
GO
alter table WFOpinionField add label_tw varchar(100) default null
GO
update syslanguage set language='简体中文' where language='中文'
GO
insert into syslanguage values(9,'繁體中文','GBK',1)
GO
alter table outrepmodule add moduletwname varchar(100) default null
GO
alter table T_OutReportCondition add conditiontwname varchar(100) default null
GO
alter table T_OutReport add twmodulefilename varchar(100) default null
GO
alter table T_OutReport add outreptwname varchar(100) default null
GO
alter table T_OutReport add outRepTwDesc varchar(100) default null
GO
alter table CRM_CustomerInfo add twname varchar(100) default null
GO
alter table T_OutReportItem add itemtwdesc varchar(100) default null
GO
alter table leftmenuinfo add customName_t varchar(100) default null
GO
alter table leftmenuconfig add customName_t varchar(100) default null
GO
alter table mainmenuinfo add customName_t varchar(100) default null
GO
alter table mainmenuconfig add customName_t varchar(100) default null
GO
alter TABLE workflow_nodecustomrcmenu add 
  submitName9 varchar(50),
	forwardName9 varchar(50),
	saveName9 varchar(50),
	rejectName9 varchar(50),
	forsubName9 varchar(50),
	ccsubName9 varchar(50),
	newWFName9 varchar(50),
	newSMSName9 varchar(50),
	subnobackName9 varchar(50),
	subbackName9 varchar(50),
	forsubnobackName9 varchar(50),
	forsubbackName9 varchar(50),
	ccsubnobackName9 varchar(50),
	ccsubbackName9 varchar(50),
	newOverTimeName9 varchar(50)
GO
