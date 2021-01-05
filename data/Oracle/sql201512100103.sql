alter table modecodedetail add shownamestr varchar(100)
/
alter table modecodedetail add fieldnamestr varchar(100)
/
create table mode_newserialnum
(
   ID INT primary key,
   codemainid int,
   condition varchar(500),
   num int
)
/
create sequence mode_newserialnum_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_newserialnum_id_Tri
before insert on mode_newserialnum
for each row
begin
select mode_newserialnum_id.nextval into :new.id from dual;
end;
/