create sequence hrm_password_protection_set_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE TABLE hrm_password_protection_set(
	id number NOT NULL primary key,
	user_id number NOT NULL,
	enabled number NOT NULL
)
/
CREATE OR REPLACE TRIGGER protection_set_Trigger before insert on hrm_password_protection_set for each row begin select hrm_password_protection_set_id.nextval into :new.id from dual; end;
/
create sequence hrm_protection_question_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE TABLE hrm_protection_question(
	id number NOT NULL primary key,
	user_id number NOT NULL,
	question varchar2(100) NOT NULL,
	answer varchar2(500) NOT NULL,
	delflag number NOT NULL
)
/
CREATE OR REPLACE TRIGGER protection_question_Trigger before insert on hrm_protection_question for each row begin select hrm_protection_question_id.nextval into :new.id from dual; end;
/