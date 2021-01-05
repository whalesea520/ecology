ALTER TABLE workflow_base ADD isfnabudgetwf CHAR(1) 
/

ALTER TABLE FnaBudgetfeeType ADD feeCtlLevel integer 
/

update FnaBudgetfeeType set feeCtlLevel = ''
/




create table fnaBudgetSet(
	workflowid integer primary key,
	km varchar2(100),
	bxlx varchar2(100),
	bxdw varchar2(100),
	bxrq varchar2(100),
	sqje varchar2(100),
	grys varchar2(100),
	bmys varchar2(100),
	fbys varchar2(100)
)
/

alter table fnaBudgetSet add fkqd integer
/

alter table fnaBudgetSet add cystxxx varchar2(4000)
/


create table fnaWfFeeCtl(
	guid char(36) primary key,
	enable char(1)
)
/

create table fnaWfFeeCtlFeeType(
	mainGuid char(36) not null,
	feeTypeId int not null,
	checkType char(4),
	PRIMARY key (mainGuid, feeTypeId)
)
/

create table fnaWfFeeCtlWf(
	mainGuid char(36) not null,
	workflowId int not null,
	PRIMARY key (mainGuid, workflowId)
)
/

create table fnabudgetCostControl(
  id integer primary key,
  workflowid integer,
  km integer,
  fylx integer,
  fydw varchar2(4000)
)
/

alter table FNABUDGETCOSTCONTROL
  add constraint idx_fnabudgetCostControl1 unique (WORKFLOWID)
/

alter table FNABUDGETCOSTCONTROL
  add constraint idx_fnabudgetCostControl2 unique (FYLX, KM, WORKFLOWID)
/

create sequence seq_fnabudgetCostControl
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/


alter table fnabudgetCostControl add jy integer
/

alter table FnaExpenseInfo add guid char(32)
/