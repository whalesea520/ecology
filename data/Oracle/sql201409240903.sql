create sequence hrm_chart_set_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_chart_set(
	id number NOT NULL primary key,
	is_sys number NOT NULL,
	author number NOT NULL,
	show_type number NOT NULL,
	show_num number NOT NULL
)
/
CREATE OR REPLACE TRIGGER hrm_chart_set_Trigger before insert on hrm_chart_set for each row begin select hrm_chart_set_id.nextval into :new.id from dual; end;
/