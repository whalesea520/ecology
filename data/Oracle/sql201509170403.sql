alter table fnaFeeWfInfo add overStandardTips VARCHAR2(4000)
/

ALTER TABLE fnaFeeWfInfoField ADD fieldValue VARCHAR2(4000)
/

ALTER TABLE fnaFeeWfInfoField ADD fieldValType integer
/

ALTER TABLE fnaFeeWfInfoField ADD fcsGuid1 char(32)
/




create table FnaCostStandard(
  guid1 char(32) PRIMARY KEY, 
  name VARCHAR2(100), 
  paramtype integer, 
  browsertype integer, 
  compareoption1 integer, 
  enabled integer, 
  orderNumber DECIMAL(5, 2), 
  Description VARCHAR2(4000) 
)
/

create index idx_fcs_2 on FnaCostStandard (name)
/
create index idx_fcs_3 on FnaCostStandard (enabled)
/


create table FnaCostStandardDefi(
  guid1 char(32) PRIMARY KEY, 
  fcsdName VARCHAR2(500), 
  csAmount VARCHAR2(4000), 
  orderNumber DECIMAL(5, 2) 
)
/

create index idx_fcsd_2 on FnaCostStandardDefi (fcsdName)
/


create table FnaCostStandardDefiDtl(
  guid1 char(32) PRIMARY KEY, 
  fcsGuid1 char(32), 
  fcsdGuid1 char(32), 
  valChar VARCHAR2(4000)
)
/

create index idx_fcsdd_2 on FnaCostStandardDefiDtl (fcsGuid1)
/
create index idx_fcsdd_3 on FnaCostStandardDefiDtl (fcsdGuid1)
/