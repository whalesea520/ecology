create table actionsettingdetail
(
    id int primary key not null,
    actionid int,
	attrname varchar(1000),
	attrvalue varchar(1000)
)
/
CREATE SEQUENCE actionsettingd_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger actionsettingd_Tri
  before insert on actionsettingdetail
  for each row
begin
  select actionsettingd_seq.nextval into :new.id from dual;
end;
/