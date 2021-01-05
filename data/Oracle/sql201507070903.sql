
create table fnaCommonInfo (
  valType char(50), 
  valStr clob
)
/

create index idx_fnaCommonInfo_1 on fnaCommonInfo (valType)
/
