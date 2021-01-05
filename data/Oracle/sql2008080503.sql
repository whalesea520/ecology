create table workflow_nodecustomrcmenu(
	id INTEGER primary key,
	wfid INTEGER not null,
	nodeid INTEGER not null,
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
	workflowid INTEGER null,
	customMessage varchar(200) null,
	fieldid INTEGER null

)
/
CREATE SEQUENCE nodecustomrcmenu_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/
CREATE OR REPLACE TRIGGER nodecustomrcmenu_Trigger before 
INSERT ON workflow_nodecustomrcmenu FOR EACH ROW
begin
select nodecustomrcmenu_sequence.nextval into :new.id from dual;
end;
/
insert into workflow_nodecustomrcmenu(wfid,nodeid,submitName7,submitName8,forwardName7,forwardName8,saveName7,saveName8,rejectName7,rejectName8,forsubName7,forsubName8,ccsubName7,ccsubName8)
select workflowid,nodeid,submitName7,submitName8,forwardName7,forwardName8,saveName7,saveName8,rejectName7,rejectName8,forsubName7,forsubName8,ccsubName7,ccsubName8
from workflow_flownode
where (submitName7 <> '' or submitName7 is not null) or (submitName8 <> '' or submitName8 is not null) or (forwardName7 <> '' or forwardName7 is not null) or (forwardName8 <> '' or forwardName8 is not null) or (saveName7 <> '' or saveName7 is not null) or (saveName8 <> '' or saveName8 is not null) or (rejectName7 <> '' or rejectName7 is not null) or (rejectName8 <> '' or rejectName8 is not null) or (forsubName7 <> '' or forsubName7 is not null) or (forsubName8 <> '' or forsubName8 is not null) or (ccsubName7 <> '' or ccsubName7 is not null) or (ccsubName8 <> '' or ccsubName8 is not null)
/
ALTER TABLE  workflow_flownode DROP COLUMN submitName7
/
ALTER TABLE  workflow_flownode DROP COLUMN submitName8
/
ALTER TABLE  workflow_flownode DROP COLUMN forwardName7
/
ALTER TABLE  workflow_flownode DROP COLUMN forwardName8
/
ALTER TABLE  workflow_flownode DROP COLUMN saveName7
/
ALTER TABLE  workflow_flownode DROP COLUMN saveName8
/
ALTER TABLE  workflow_flownode DROP COLUMN rejectName7
/
ALTER TABLE  workflow_flownode DROP COLUMN rejectName8
/
ALTER TABLE  workflow_flownode DROP COLUMN forsubName7
/
ALTER TABLE  workflow_flownode DROP COLUMN forsubName8
/
ALTER TABLE  workflow_flownode DROP COLUMN ccsubName7
/
ALTER TABLE  workflow_flownode DROP COLUMN ccsubName8
/