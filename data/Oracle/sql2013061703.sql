CREATE TABLE blog_location
	(
	id         INT NOT NULL,
	discussid  INT NULL,
	location   VARCHAR (100) NULL,
	createtime VARCHAR (8) NULL
	)
/
create sequence blog_location_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_location_id_trigger
before insert on blog_location
for each row
begin
select blog_location_id.nextval into :new.id from dual;
end;
/