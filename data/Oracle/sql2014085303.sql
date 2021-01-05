create table actionsetting
(
	id int primary key not null,
	actionname varchar(200),
	actionclass varchar(2000),
	typename varchar(20)
)
/
CREATE SEQUENCE actionsetting_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger actionsetting_Tri
  before insert on actionsetting
  for each row
begin
  select actionsetting_seq.nextval into :new.id from dual;
end;
/