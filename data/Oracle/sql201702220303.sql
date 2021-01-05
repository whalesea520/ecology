create table ldapsynclog (
ID int not null,
DataId int,
DataType int,
OperationType int,
CreateDate varchar(10),
CreateTime varchar(8)
)
/
alter table ldapsynclog
  add primary key (ID)
/
  create sequence seq_ldapsynclog  increment  by 1
  start with 1
  minvalue 1
  maxvalue 9999999999
  
/
 create or replace trigger trg_ldapsynclog
before insert
on ldapsynclog
for each row
declare
newid number(18,0);
begin
select seq_ldapsynclog.nextval into newid from dual;
:new.ID:=newid;
end;
/