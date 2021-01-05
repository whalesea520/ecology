ALTER table FnaCostStandard add fielddbtype varchar2(200)
/



CREATE TABLE fnaFeeWfInfoCostStandard(
	id integer NOT NULL PRIMARY KEY,
	workflowid integer,
	enable integer,
	FNAWFTYPE varchar2(50),
	OVERSTANDARDTIPS varchar2(4000),
	lastModifiedDate CHAR(10)
)
/

create index idx_fnaFeeWfInfoCs on fnaFeeWfInfoCostStandard (workflowid)
/

create index idx_fnaFeeWfInfoCs1 on fnaFeeWfInfoCostStandard (FNAWFTYPE)
/

create index idx_fnaFeeWfInfoCs2 on fnaFeeWfInfoCostStandard (ENABLE)
/

create sequence seq_fnaFeeWfInfoCs_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create or replace trigger fnaFeeWfInfoCs_trigger 
before insert 
on fnaFeeWfInfoCostStandard 
for each row 
begin 
	select seq_fnaFeeWfInfoCs_id.nextval into :new.id from dual; 
end;
/






CREATE TABLE fnaFeeWfInfoFieldCostStandard(
	id integer NOT NULL PRIMARY KEY,
	mainId integer,
	
	workflowid integer,
	formid integer,
	
	fieldType integer,
	fieldId integer,
	FCSGUID1 char(32),
	TABINDEX integer,
	SHOWALLTYPE integer,
	DTLNUMBER integer,

	FIELDVALUE varchar2(4000),
	FIELDVALTYPE integer,
	FIELDVALUEWFSYS integer,
	ISWFFIELDLINKAGE integer,

	isDtl integer
)
/

create index idx_fnaFeeWfInfoFieldCs on fnaFeeWfInfoFieldCostStandard (mainId)
/

create index idx_fnaFeeWfInfoFieldCs2 on fnaFeeWfInfoFieldCostStandard (workflowid)
/

create index idx_fnaFeeWfInfoFieldCs5 on fnaFeeWfInfoFieldCostStandard (FCSGUID1)
/

create sequence seq_fnaFeeWfInfoFieldCs_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/


create or replace trigger fnaFeeWfInfoFieldCs_trigger 
before insert 
on fnaFeeWfInfoFieldCostStandard 
for each row 
begin 
	select seq_fnaFeeWfInfoFieldCs_id.nextval into :new.id from dual; 
end;
/