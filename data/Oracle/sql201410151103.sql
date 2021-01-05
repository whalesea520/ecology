CREATE TABLE multilang_permission_list(
	id integer  NOT NULL primary key,
	userid int,
	wbList int
)
/
create sequence multilang_permission_list_id
   minvalue 1
   maxvalue 999999999999999999999999999
   start with 1
   increment by 1
   cache 20
/
create or replace trigger   multilang__id_TRIGGER 
  before insert on multilang_permission_list
  for each row
begin
  select multilang_permission_list_id.nextval into :new.id from dual;
end;
/
alter table SystemSet add wbList int
/