create  table  ecologyuplist (
	id integer NOT NULL,
	label varchar2(100)
)
/

create sequence ecologyuplist_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ecologyuplist_Trigger
before insert on ecologyuplist
for each row
begin
select ecologyuplist_id.nextval into :new.id from dual;
end;
/
