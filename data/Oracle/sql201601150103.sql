create table SHAREINNERWFURGER
(
  id         INTEGER not null,
  requestid  INTEGER not null,
  workflowid INTEGER,
  utype      INTEGER,
  objvalue   VARCHAR2(40),
  levelmin   INTEGER,
  levalmax   INTEGER
)
/
create index SHAREINNERWFURGER_IDX_ALL on SHAREINNERWFURGER (UTYPE, OBJVALUE, LEVELMIN, LEVALMAX)
/
create index SHAREINNERWFURGER_IDX_OBJVALUE on SHAREINNERWFURGER (UTYPE, OBJVALUE)
/
create index SHAREINNERWFURGER_IDX_TYPE on SHAREINNERWFURGER (UTYPE)
/
alter table SHAREINNERWFURGER
  add primary key (ID)
  using index
/