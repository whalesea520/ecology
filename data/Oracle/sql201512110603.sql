create sequence hrm_schedule_personnel_val_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_schedule_personnel_val (
	id number primary key not null,
	delflag number not null,
	field001 number not null,
	field002 number not null
)
/
CREATE OR REPLACE TRIGGER hrm_schedule_pv_tri before insert on hrm_schedule_personnel_val for each row begin select hrm_schedule_personnel_val_id.nextval into :new.id from dual; end;
/
