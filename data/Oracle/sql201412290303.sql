create sequence hrm_usb_auto_date_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_usb_auto_date ( 
	id number not null PRIMARY KEY,
	user_id number not null,
	need_auto number not null,
	enable_date varchar2(50) null,
	enable_usb_type number not null,
	delflag number not null
)
/
CREATE OR REPLACE TRIGGER usb_auto_date_Trigger before insert on hrm_usb_auto_date for each row begin select hrm_usb_auto_date_id.nextval into :new.id from dual; end;
/