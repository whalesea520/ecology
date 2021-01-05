create table hrm_transfer_log_bak as select * from hrm_transfer_log 
/
alter table hrm_transfer_log_bak add idbak varchar2(1000)
/
update hrm_transfer_log_bak set idbak = id 
/
alter table hrm_transfer_log_bak drop column id
/
alter table hrm_transfer_log_bak rename column idbak to id
/
alter table hrm_transfer_log rename to hrm_transfer_log_backup
/
alter table hrm_transfer_log_bak rename to hrm_transfer_log
/
create table hrm_transfer_log_detail_bak as select * from hrm_transfer_log_detail 
/
alter table hrm_transfer_log_detail_bak add idbak varchar2(1000)
/
update hrm_transfer_log_detail_bak set idbak = log_id 
/
alter table hrm_transfer_log_detail_bak drop column log_id
/
alter table hrm_transfer_log_detail_bak rename column idbak to log_id
/
alter table hrm_transfer_log_detail rename to hrm_transfer_log_detail_bakup
/
alter table hrm_transfer_log_detail_bak rename to hrm_transfer_log_detail
/
drop trigger TRANSFER_LOG_DETAIL_TRIGGER
/
create or replace trigger "TRANSFER_LOG_DETAIL_TRIGGER"
  before insert on hrm_transfer_log_detail
  for each row
begin
  select hrm_transfer_log_detail_id.nextval into :new.id from dual;
end;
/