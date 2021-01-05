create sequence hrm_user_status_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_user_status ( 
	id number not null PRIMARY KEY,
	user_id number not null,
	online_flag number not null
)
/
CREATE OR REPLACE TRIGGER hrm_user_status_Trigger before insert on hrm_user_status for each row begin select hrm_user_status_id.nextval into :new.id from dual; end;
/