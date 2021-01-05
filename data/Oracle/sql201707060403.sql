CREATE TABLE mode_import_template(
	id int  ,
	modeid int,
	formid int,
	fieldid int ,
	dsporder float 
)
/

create sequence mode_import_template_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_import_template_Tri
before insert on mode_import_template
for each row
begin
select mode_import_template_id.nextval into :new.id from dual;
end;
/