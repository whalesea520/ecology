create table FnaBatch4Subject(
  guid1 char(32),
  id int,
  groupCtrl CHAR(1), 
  ISEDITFEETYPEGUID CHAR(32), 
  ISEDITFEETYPEID INT, 
  groupCtrlGuid CHAR(32), 
  archive int, 
  feeperiod int 
)
go

create index idx_FnaBatch4Subject_1 on FnaBatch4Subject(id)
go
create index idx_FnaBatch4Subject_2 on FnaBatch4Subject(guid1)
go