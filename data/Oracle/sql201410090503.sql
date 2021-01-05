create table hrm_transfer_log(
  id number NOT NULL primary key,
  type varchar2(50) NOT NULL,
  fromid varchar2(50) NOT NULL,
  toid varchar2(1000) NOT NULL,
  p_type number NOT NULL,
  p_begin_date timestamp NOT NULL,
  p_finish_date timestamp,
  p_member number NOT NULL,
  p_ip varchar2(50),
  p_status number NOT NULL,
  is_read number NOT NULL,
  read_date timestamp,
  p_time number NOT NULL,
  all_num number NOT NULL
)
/
create sequence hrm_transfer_log_detail_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_transfer_log_detail(
  id number NOT NULL primary key,
  log_id number NOT NULL,
  code_name varchar2(50) NOT NULL,
  p_num number NOT NULL,
  is_all number NOT NULL,
  id_str varchar2(4000),
  p_time number NOT NULL
)
/
CREATE OR REPLACE TRIGGER transfer_log_detail_Trigger before insert on hrm_transfer_log_detail for each row begin select hrm_transfer_log_detail_id.nextval into :new.id from dual; end;
/