create sequence hrm_att_vacation_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE TABLE hrm_att_vacation(
	id number NOT NULL primary key,
	field001 number NOT NULL,
	field002 number NOT NULL,
	field003 number NOT NULL,
	field004 varchar2(100) NOT NULL,
	field005 varchar2(100) NOT NULL,
	field006 varchar2(100) NOT NULL,
	field007 varchar2(100) NOT NULL,
	field008 varchar2(100) NOT NULL,
	field009 number NOT NULL,
	field010 number NOT NULL
)
/
CREATE OR REPLACE TRIGGER hrm_att_vacation_Trigger before insert on hrm_att_vacation for each row begin select hrm_att_vacation_id.nextval into :new.id from dual; end;
/
