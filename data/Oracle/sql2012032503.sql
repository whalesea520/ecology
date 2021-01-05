CREATE TABLE blog_notes
	(
	id         integer NOT NULL,
	userid     integer NOT NULL,
	updatedate VARCHAR2 (10) NULL,
	content    clob NULL,
	isRemind   integer NULL
	)
/
create sequence blog_notes_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger blog_notes_id_trigger
before insert on blog_notes
for each row
begin
select blog_notes_id.nextval into :new.id from dual;
end;
/