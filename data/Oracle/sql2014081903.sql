alter table FnaBudgetfeeType add groupCtrl char(1)
/

update FnaBudgetfeeType set groupCtrl = null where feelevel = 1 or feelevel = 2
/

update FnaBudgetfeeType set groupCtrl = '1' where feelevel = 3
/

ALTER TABLE FnaBudgetfeeType add isEditFeeType integer
/

update FnaBudgetfeeType set isEditFeeType = 0 
/





update workflow_browserurl set linkurl = '/fna/budget/FnaBudgetView.jsp?budgetinfoid=' where id = 134
/

create table fnaRuleSet(
  id integer NOT NULL PRIMARY KEY,
  roleid integer not null,
  allowZb integer not null,
	name VARCHAR2(4000)
)
/

create sequence seq_fnaRuleSet_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create table fnaRuleSetDtl(
  id integer NOT NULL PRIMARY KEY,
  mainid integer not null,
  showid integer not null,
	showidtype integer not null
)
/

create sequence seq_fnaRuleSetDtl_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create table fnaRuleSetDtl1(
  id integer NOT NULL PRIMARY KEY,
  mainid integer not null,
  showid integer not null,
	showidtype integer not null
)
/

create sequence seq_fnaRuleSetDtl1_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

alter table FnaSystemSet add showHiddenSubject char(1)
/

update FnaSystemSet set showHiddenSubject = '0'
/




ALTER TABLE FnaSystemSet ADD remark VARCHAR2(4000)
/

ALTER TABLE FnaSystemSet ADD enableGlobalFnaCtrl integer
/

ALTER TABLE FnaSystemSet ADD alertvalue integer
/

ALTER TABLE FnaSystemSet ADD agreegap integer
/

update FnaSystemSet set enableGlobalFnaCtrl = 1
/








CREATE TABLE fnaFeeWfInfo(
	id integer NOT NULL PRIMARY KEY,
	workflowid integer,
	enable integer,
	lastModifiedDate CHAR(10)
)
/

create index idx_fnaFeeWfInfo on FNAFEEWFINFO (workflowid)
/

create sequence seq_fnaFeeWfInfo_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/



CREATE TABLE fnaFeeWfInfoField(
	id integer NOT NULL PRIMARY KEY,
	mainId integer,
	
	workflowid integer,
	formid integer,
	
	fieldType integer,
	fieldId integer,
	isDtl integer
)
/

create index idx_fnaFeeWfInfoField on fnaFeeWfInfoField (mainId)
/

create sequence seq_fnaFeeWfInfoField_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/



CREATE TABLE fnaFeeWfInfoLogic(
	id INT NOT NULL PRIMARY KEY,
	mainId integer,
	
	kmIdsCondition integer,
	kmIds VARCHAR2(4000),
	orgType integer,
	orgIdsCondition integer,
	orgIds VARCHAR2(4000),
	
	intensity integer,
	
	promptSC VARCHAR2(4000),
	promptTC VARCHAR2(4000),
	promptEN VARCHAR2(4000)
)
/

create index idx_fnaFeeWfInfoLogic on fnaFeeWfInfoLogic (mainId)
/

create sequence seq_fnaFeeWfInfoLogic_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/



CREATE TABLE fnaControlScheme(
	id integer NOT NULL PRIMARY KEY,
	
	name char(60),
	code char(60),
	
	fnayearid integer,
	fnayearidEnd integer,
	
	enabled integer
)
/

create index idx_fnaControlScheme_name on fnaControlScheme (name)
/

create index idx_fnaControlScheme_code on fnaControlScheme (code)
/

create index idx_fnaControlScheme_fnayearid on fnaControlScheme (fnayearid)
/

create index idx_fnaControlScheme_enabled on fnaControlScheme (enabled)
/

create sequence seq_fnaControlScheme_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/



CREATE TABLE fnaControlSchemeDtl(
	id INT NOT NULL PRIMARY KEY,
	mainId integer,
	
	kmIdsCondition integer,
	kmIds VARCHAR2(4000),
	orgType integer,
	orgIdsCondition integer,
	orgIds VARCHAR2(4000),
	
	intensity integer,
	
	promptSC VARCHAR2(4000),
	promptTC VARCHAR2(4000),
	promptEN VARCHAR2(4000)
)
/

create index idx_fnaControlSchemeDtl on fnaControlSchemeDtl (mainId)
/

create sequence seq_fnaControlSchemeDtl_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/


CREATE TABLE fnaControlScheme_FeeWfInfo(
  fnaControlSchemeId integer NOT NULL,
  fnaFeeWfInfoId integer NOT NULL,
  primary key (fnaControlSchemeId, fnaFeeWfInfoId)
)
/

alter table fnaFeeWfInfoLogic add workflowid integer
/

create or replace trigger fnaControlScheme_trigger 
before insert 
on fnaControlScheme 
for each row 
begin 
	select seq_fnaControlScheme_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaControlSchemeDtl_trigger 
before insert 
on fnaControlSchemeDtl 
for each row 
begin 
	select seq_fnaControlSchemeDtl_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaFeeWfInfo_trigger 
before insert 
on fnaFeeWfInfo 
for each row 
begin 
	select seq_fnaFeeWfInfo_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaFeeWfInfoField_trigger 
before insert 
on fnaFeeWfInfoField 
for each row 
begin 
	select seq_fnaFeeWfInfoField_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaFeeWfInfoLogic_trigger 
before insert 
on fnaFeeWfInfoLogic 
for each row 
begin 
	select seq_fnaFeeWfInfoLogic_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaRuleSet_trigger 
before insert 
on fnaRuleSet 
for each row 
begin 
	select seq_fnaRuleSet_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaRuleSetDtl_trigger 
before insert 
on fnaRuleSetDtl 
for each row 
begin 
	select seq_fnaRuleSetDtl_id.nextval into :new.id from dual; 
end;
/


create or replace trigger fnaRuleSetDtl1_trigger 
before insert 
on fnaRuleSetDtl1 
for each row 
begin 
	select seq_fnaRuleSetDtl1_id.nextval into :new.id from dual; 
end;
/

