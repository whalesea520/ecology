CREATE TABLE Workflow_BarCodeSet(
	id integer NOT NULL ,
	workflowId integer NULL ,
	isUse char(1) NULL ,
	measureUnit char(1) NULL ,
	printRatio integer NULL ,
	minWidth integer NULL ,
	maxWidth integer NULL ,
	minHeight integer NULL ,
	maxHeight integer NULL ,
	bestWidth integer NULL ,
	bestHeight integer NULL 
)
/

create sequence Workflow_BarCodeSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Workflow_BarCodeSet_Tri
before insert on Workflow_BarCodeSet
for each row
begin
select Workflow_BarCodeSet_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Workflow_BarCodeSetDetail(
	id integer NOT NULL ,
	barCodeSetId integer NULL ,
	dataElementId integer NULL ,
	fieldId integer NULL 
)
/

create sequence Wf_BarCodeSetDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Wf_BarCodeSetDetail_Tri
before insert on Workflow_BarCodeSetDetail
for each row
begin
select Wf_BarCodeSetDetail_id.nextval into :new.id from dual;
end;
/
