INSERT INTO workflow_browdef_fieldconf (id,fieldtype,fieldname,namelabel,conditionfieldtype,defaultshoworder) 
VALUES(91,22,'fnabudgetfeetype',854,'fnabudgetfeetype','1.5')
/
INSERT INTO workflow_browdef_fieldconf (id,fieldtype,fieldname,namelabel,conditionfieldtype,defaultshoworder) 
VALUES(92,251,'fnacostcenter',515,'fnacostcenter','1.5')
/

CREATE TABLE FnaFeetypeWfbrowdef(
	id integer PRIMARY KEY NOT NULL,
	workflowid integer ,
	fieldId integer ,
	viewType integer ,
	fieldType integer ,
	title VARCHAR2(2000)
)
/
create sequence FnaFeetypeWfbrowdef_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create index idx_FnaFeeWfbrowdef_workflowid on FnaFeetypeWfbrowdef (workflowid)
/
create index idx_FnaFeeWfbrowdef_fieldid on FnaFeetypeWfbrowdef (fieldId)
/
create index idx_FnaFeeWfbrowdef_fieldType on FnaFeetypeWfbrowdef (fieldType)
/
CREATE TABLE FnaFeetypeWfbrowdef_dt1(
	id integer PRIMARY KEY NOT NULL,
	mainid integer ,
	refid integer 
)
/
create sequence FnaFeeWfbrowdefDt_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/
create index idx_FnaFeeWfbrowdefDt_mainid on FnaFeetypeWfbrowdef_dt1 (mainid)
/
