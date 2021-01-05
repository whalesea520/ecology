CREATE TABLE mobile_rongGroupNotice (
	id integer  not null,
	targetid varchar(1000),
	sendid integer NOT NULL,
	content varchar(4000),
	operate_date varchar(50) NOT NULL
)
/
create sequence mobile_rongGroupNotice_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mobile_rongGroupNotice_trigger
before insert on mobile_rongGroupNotice
for each row
begin
select mobile_rongGroupNotice_id.nextval into :new.id from dual;
end;
/