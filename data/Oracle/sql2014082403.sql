create table mobileHideModule(
	id int NOT NULL,
	userid integer NOT NULL, 
	moduleid integer NOT NULL
)
/

create sequence mHideModule_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mHideModule_tri
before insert on mobileHideModule
for each row
begin
	select mHideModule_id.nextval into :new.id from dual;
end;
/
