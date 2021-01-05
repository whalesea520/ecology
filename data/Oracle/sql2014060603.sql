
alter table DocPopUpInfo add pop_type integer null
/


create table DocPopUpUser(
    id  integer  primary key ,
    userid  integer,
    docid  integer,
    haspopnum  integer,
    beiyong varchar2(200)
)
/

create sequence DocPopUpUser_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocPopUpUser_Trigger
before insert on DocPopUpUser
for each row
begin
select DocPopUpUser_id.nextval into :new.id from dual;
end;
/