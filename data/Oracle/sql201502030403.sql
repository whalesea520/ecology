CREATE TABLE ModeFieldAuthorize(
	id int PRIMARY KEY NOT NULL,
	modeid int NULL,
	formid int NULL,
	fieldid int NULL,
	opttype int NULL,
	layoutid int NULL,
	layoutlevel int NULL
)
/
create sequence ModeFieldAuthorize_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create or replace trigger ModeFieldAuthorize_Trigger before insert on ModeFieldAuthorize for each row 
begin select ModeFieldAuthorize_ID.nextval into :new.id from dual; end;
/