alter table ImageFile add objId  integer
/
alter table ImageFile add objotherpara  varchar2(1000)
/

create table ImageFileSource (
	id integer  NOT NULL ,
	imageFileId integer  null,
	comefrom varchar2(1000)  null,
	objId integer  null,
	objotherpara varchar2(1000)  null
)
/
create sequence ImageFileSource_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ImageFileSource_id_trigger
before insert on ImageFileSource
for each row 
begin
select ImageFileSource_id.nextval into :new.id from dual;
end;
/