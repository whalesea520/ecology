create table workflow_nodecustomrcmenu(
	id int IDENTITY (1, 1) NOT NULL,
	wfid int not null,
	nodeid int not null,
	submitName7 varchar(50) null,
	submitName8 varchar(50) null,
	forwardName7 varchar(50) null,
	forwardName8 varchar(50) null,
	saveName7 varchar(50) null,
	saveName8 varchar(50) null,
	rejectName7 varchar(50) null,
	rejectName8 varchar(50) null,
	forsubName7 varchar(50) null,
	forsubName8 varchar(50) null,
	ccsubName7 varchar(50) null,
	ccsubName8 varchar(50) null,
	newWFName7 varchar(50) null,
	newWFName8 varchar(50) null,
	newSMSName7 varchar(50) null,
	newSMSName8 varchar(50) null,
	haswfrm char(1) null,
	hassmsrm char(1) null,
	workflowid int null,
	customMessage varchar(200) null,
	fieldid int null

)
GO
insert into workflow_nodecustomrcmenu(wfid,nodeid,submitName7,submitName8,forwardName7,forwardName8,saveName7,saveName8,rejectName7,rejectName8,forsubName7,forsubName8,ccsubName7,ccsubName8)
select workflowid,nodeid,submitName7,submitName8,forwardName7,forwardName8,saveName7,saveName8,rejectName7,rejectName8,forsubName7,forsubName8,ccsubName7,ccsubName8
from workflow_flownode
where (submitName7 <> '' and submitName7 is not null) or (submitName8 <> '' and submitName8 is not null) or (forwardName7 <> '' and forwardName7 is not null) or (forwardName8 <> '' and forwardName8 is not null) or (saveName7 <> '' and saveName7 is not null) or (saveName8 <> '' and saveName8 is not null) or (rejectName7 <> '' and rejectName7 is not null) or (rejectName8 <> '' and rejectName8 is not null) or (forsubName7 <> '' and forsubName7 is not null) or (forsubName8 <> '' and forsubName8 is not null) or (ccsubName7 <> '' and ccsubName7 is not null) or (ccsubName8 <> '' and ccsubName8 is not null)
GO
ALTER TABLE  workflow_flownode DROP COLUMN submitName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN submitName8
GO
ALTER TABLE  workflow_flownode DROP COLUMN forwardName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN forwardName8
GO
ALTER TABLE  workflow_flownode DROP COLUMN saveName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN saveName8
GO
ALTER TABLE  workflow_flownode DROP COLUMN rejectName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN rejectName8
GO
ALTER TABLE  workflow_flownode DROP COLUMN forsubName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN forsubName8
GO
ALTER TABLE  workflow_flownode DROP COLUMN ccsubName7
GO
ALTER TABLE  workflow_flownode DROP COLUMN ccsubName8
GO