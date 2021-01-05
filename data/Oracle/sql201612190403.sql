create table FnaBatch4Subject(
  guid1 char(32),
  id integer,
  groupCtrl CHAR(1), 
  ISEDITFEETYPEGUID CHAR(32), 
  ISEDITFEETYPEID INTEGER, 
  groupCtrlGuid CHAR(32), 
  archive INTEGER, 
  feeperiod INTEGER 
)
/

create index idx_FnaBatch4Subject_1 on FnaBatch4Subject(id)
/
create index idx_FnaBatch4Subject_2 on FnaBatch4Subject(guid1)
/